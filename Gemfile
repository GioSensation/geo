source 'https://rubygems.org'
ruby '2.1.2'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'json'
gem 'data_mapper'

group :development do
	gem 'unicorn'
	gem 'guard'
	gem 'listen'
	gem 'rb-inotify', :require => false
	gem 'rb-fsevent', :require => false
	gem 'guard-unicorn'
	gem 'dm-sqlite-adapter'
end

group :production do
	gem 'pg'
	gem 'dm-postgres-adapter'
end
