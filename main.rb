require 'sinatra/base'

class Geo < Sinatra::Base
	
	# CONFIG
#	configure :development do
#		DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
#		
#		# Create or upgrade or migrate all tables
#		DataMapper.auto_upgrade!
#	end
	
	configure :production do
		DataMapper.setup(:default, ENV['DATABASE_URL'])
	end
	
	# ROUTES
	get '/' do
		erb :home
	end
	
	get '/get-position' do
		
	end
end