require 'rubygems'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'

# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be set, when working locally this line will fall back to using SQLite in the current directory.
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db")

# Define a simple DataMapper model.
class Mammoccio
	include DataMapper::Resource
	
	property :id, 			Serial, 	:key => true
	property :email,		String,		:length => 5..70, :unique => true, :required => true, :format => :email_address
	property :password,		BCryptHash
	property :located_time, DateTime
	property :latitude,		Decimal, {:precision=>10, :scale=>6}
	property :longitude,	Decimal, {:precision=>10, :scale=>6}
	property :friends,		CommaSeparatedList
	
	def authenticate(attempted_password)
		if self.password == attempted_password
			true
		else
			false
		end
	end
	
end

# Finalize the DataMapper model.
DataMapper.finalize
	
# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!