source 'https://rubygems.org'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'dm-core'
gem 'dm-migrations'

group :development do
	gem 'unicorn'
	gem 'guard'
	gem 'listen'
	gem 'rb-inotify', :require => false
	gem 'rb-fsevent', :require => false
	gem 'guard-unicorn'
	gem "dm-sqlite-adapter"
end

group :production do
	gem 'pg'
	gem "dm-postgres-adapter"
end