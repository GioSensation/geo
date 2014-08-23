require 'sinatra/base'
require 'json'
require 'sinatra/json'
require 'data_mapper'

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
	
end

class Geo < Sinatra::Base
	
	helpers GeoHelpers
	
	# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be set, when working locally this line will fall back to using SQLite in the current directory.
	DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
	
	# Define a simple DataMapper model.
	class Coords
		include DataMapper::Resource
		
		property :id, Serial, :key => true
		property :created_at, DateTime
		property :latitude, Decimal, {:precision=>10, :scale=>6}
		property :longitude, Decimal, {:precision=>10, :scale=>6}
	end
	
	# Finalize the DataMapper model.
	DataMapper.finalize
		
	# Tell DataMapper to update the database according to the definitions above.
	DataMapper.auto_upgrade!
	
	# ROUTES
	get '/' do
		erb :home
	end
	
	post '/save-coords' do
		content_type :json
		request.body.rewind  # in case someone already read it
		data = JSON.parse(request.body.read)
#		"#{data}"
		ratto = distance [data['latitude'], data['longitude']], [42.962109685071006, 13.875682386939918]
		"#{ratto}"
		
#		@coords = Coords.create(data)
	end
end