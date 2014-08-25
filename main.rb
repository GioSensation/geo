require 'sinatra/base'
require 'json'
require 'sinatra/json'
require 'data_mapper'

require 'bundler'
Bundler.require

# Require our Auth functionality
require './auth'

module GeoHelpers
	
	def distance a, b
		# Haversine calculation as seen here: http://stackoverflow.com/questions/12966638/rails-how-to-calculate-the-distance-of-two-gps-coordinates-without-having-to-u
		rad_per_deg = Math::PI/180  # PI / 180
		rkm = 6371                  # Earth radius in kilometers
		rm = rkm * 1000             # Radius in meters
	
		dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
		dlat_rad = (b[0]-a[0]) * rad_per_deg
	
		lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
		lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }
	
		a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
		c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
	
		rm * c # Delta in meters
	end
	
	def auth_and_get_user warden_var
		# Are you logged in, you bastard?
		warden_var.authenticate!
		user_id = warden_var.user.id
		@user = Mammoccio.get(user_id)
	end
	
end

class Geo < Sinatra::Base
	
	enable :sessions
	register Sinatra::Flash
	
	helpers GeoHelpers
	
	use Warden::Manager do |config|
		# Tell Warden to save our Mammoccio info into a session. We will store the Mammoccio's id.
		config.serialize_into_session{|mammoccio| mammoccio.id}
		# Tell Warden to take what we've stored in the session and retrieve the corresponding user.
		config.serialize_from_session{|id| Mammoccio.get(id)}
		
		config.scope_defaults :default,
		# Strategies is an array of methods that perform the authentication.
		strategies: [:password],
		# The action is a route to send the user when the check for auth has failed.
		action: '/auth/unauthenticated'
		# This specifies where to send the user when he fails to log in.
		config.failure_app = self
	end
	
	Warden::Manager.before_failure do |env,opts|
		env['REQUEST_METHOD'] = 'POST'
	end
	
	Warden::Strategies.add(:password) do
		def valid?
			params['mammoccio'] && params['mammoccio']['email'] && params['mammoccio']['password']
		end
		
		def authenticate!
			user = Mammoccio.first(email: params['mammoccio']['email'])
			
			if user.nil?
				fail!('The username you entered does not exist.')
			elsif user.authenticate(params['mammoccio']['password'])
				success!(user)
			else
				fail!('Could not log in. You are free to feel bad and send us bad, bad words.')
			end
		end
	end
	
	# ROUTES
	get '/' do
		erb :home
	end
	
	get '/register' do
		erb :register
	end
	
	post '/register' do
		if @user = Mammoccio.create(params[:mammoccio])
			flash[:success] = "You have successfully registered and are now logged in. Get started immediately!"
			env['warden'].set_user(@user)
			redirect '/protected'
		else
			redirect '/register'
			flash[:error] = "Something went wrong"
		end
	end
	
	get '/auth/login' do
		erb :login
	end
	
	post '/auth/login' do
		env['warden'].authenticate!
		
		flash[:success] = env['warden'].message
		
		if session[:return_to].nil?
			redirect '/protected'
		else
			redirect session[:return_to]
		end
	end
	
	get '/auth/logout' do
		env['warden'].raw_session.inspect
		env['warden'].logout
		flash[:success] = 'Successfully logged out'
		redirect '/'
	end
	
	post '/auth/unauthenticated' do
		session[:return_to] = env['warden.options'][:attempted_path]
		puts env['warden.options'][:attempted_path]
		puts env['warden']
		flash[:error] = env['warden'].message || 'You must log in'
		redirect '/auth/login'
	end
	
	get '/protected' do
		auth_and_get_user(env['warden'])
		erb :protected
	end
		
	patch '/save-coords' do
		auth_and_get_user(env['warden'])
		
		content_type :json
		request.body.rewind  # in case someone already read it
		data = JSON.parse(request.body.read)
		
		if @user.update!(:located_time => Time.now, :latitude => data['latitude'], :longitude => data['longitude'])
			ratto = distance [data['latitude'], data['longitude']], [42.962109685071006, 13.875682386939918]
			"#{ratto}, #{data['latitude']}"
		else
			"error"
		end
		
#		@coords = Coords.create(data)
	end
	
	patch '/add-friend/:id' do
		auth_and_get_user(env['warden'])
		@user.friends << params[:id]
		if @user.save
			"Success!"
		else
			"Error!"
		end
	end
end