#require activity model
require './app/models/activity.rb'



#
# GET '/' ,get all activities
#
def index
	@activities = Activity.all :order => :id.desc
	if @activities.empty?
		flash[:error] = 'No Activities found.'
	end 
	@title = 'All Activities for all users'

	#get json format for array of activities
	arr = Array(Activity.all)
    @json_format ={ 'Activities' => arr}.to_json

	#redirect to home page
	erb :home
end




#
# POST '/' ,creates new activity
#
def create
	@activity = Activity.new
	time = Date.new(2013,1,1)
	#set attributes
	@activity.description = params[:description]
	@activity.user_id = params[:user_id]
	@activity.parent_or_child = params[:user_type]
	@activity.type = params[:type]
	@activity.created_at = time
	@activity.day = time.day
	@activity.month = time.month
	@activity.year = time.year
	#save activity
	@activity.save
end



#
#GET '/activity/:id' ,gets activity with params[:id]
#
def show
	@activity = Activity.get params[:id]
	@title = "Edit activity ##{params[:id]}"

	#redirect to edit
	erb :edit
end



#
#GET '/user/:user_id' , get all activities with params[:user_id]
#
def get_all_activties_for_user

	@activities = Activity.all(:user_id => params[:user_id]) 

	#get json format
	arr = Array(@activities) 
    @json_format ={ 'Activities' => arr}.to_json
	@title = "All Activities for ##{params[:user_id]}"
	#redirect to home page
	erb :home
end



#
#PUT '/:id' ,edits activity with params[:id]
#
def edit
	activity = Activity.get params[:id]
	activity.description = params[:description]
	activity.save
	#redirect to home page
	erb :home
end


#
#DELETE '/:id' get activity with params[:id] 
#and redirect to delete page
#
def delete
	@activity = Activity.get params[:id]
	@title = "Confirm deletion of note ##{params[:id]}"
	#redirect to delete page
	erb :delete
end


#
#GET '/activities/:group_by' get activity with params[:id] 
#and redirect to delete page
#
def get_number_of_activities(group_by)

	@group_by = group_by
	if(group_by == 'day')
		@data =  Activity.aggregate(:day,:type,:all.count)
	elsif (group_by == 'month')
		@data =  Activity.aggregate(:month,:type,:all.count)
	elsif (group_by == 'year')
		@data =  Activity.aggregate(:year,:type,:all.count)
	end
	

	@title = "Activities for each type"

	erb :reporting

end