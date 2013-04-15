require 'sinatra'
require 'dm-core'  
require 'dm-timestamps'  
require 'dm-validations'  
require 'dm-migrations'  
require 'dm-aggregates'  
require 'active_support/core_ext/numeric/time'
require 'json'
require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra/base'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require 'active_support/core_ext/time/calculations'

class ActivityApp < Sinatra::Base

#enable sessions and flash
enable :sessions
use Rack::Flash, :sweep => true

#set DataMapper database file
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/activities.db")

#require all models and controllers
Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/controllers/*.rb"].each { |file| require file }

#auto upgrade DataMapper
DataMapper.auto_upgrade!

#helpers
helpers do
	include Rack::Utils
	alias_method :h, :escape_html
end

# 
#--------------------------------------------------- Application----------------------------------------------------------
#

#
#get all activities
#
get '/' do
	index
end
#
#get specific activity
#
get '/activity/:id' do
	show
end
#
#get all activities for specific user
#
get '/user/:user_id' do
	get_all_activties_for_user	
end
#
#redirect to delete page
#
get '/:id/delete' do
	delete
end
#
#create new activity
#
post '/' do
	create
	redirect '/'	
end
#
#edit attr of new activity
#
put '/:id' do
	edit
end
#
#delete activity
#
post '/activity/:id' do
	activity = Activity.get params[:id]
	activity.destroy
	redirect '/'
end

get '/activities/:group_by' do

get_number_of_activities(params[:group_by])

end

end

#Run main app
ActivityApp.run!