require 'sinatra/base'
require 'json'
require 'sinatra/json'
require 'data_mapper'

class Geo < Sinatra::Base
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
#		@coords = Coords.create(data)
	end
end