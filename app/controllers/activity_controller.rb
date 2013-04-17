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
	time = Time.now
	#set attributes
	@activity.description = params[:description]
	@activity.user_id = params[:user_id]
	@activity.parent_or_child = params[:user_type]
	@activity.type = params[:type]
	@activity.created_at = Date.new(2011,4,17)
	@activity.created_at_time = time

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

	@title = "Activities for each type"
	@attribute_name = 'Activity type '

	@adapter = DataMapper.repository(:default).adapter
	@adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::Underscored

	if(group_by == 'day')
		@data =  @adapter.select("Select type,created_at, COUNT (type) As cnt from activities
		Group by type,strftime('%Y', created_at),strftime('%m', created_at),strftime('%d', created_at)
		order by cnt asc;")

		erb :activities_group_by_day
	elsif (group_by == 'month')
		@data =  @adapter.select("Select type,strftime('%m', created_at) as month, strftime('%Y', created_at) as year, COUNT (type) As cnt from activities
		Group by type,strftime('%Y', created_at),strftime('%m', created_at)
		order by cnt asc;")
		erb :activities_group_by_month
	elsif (group_by == 'year')
		@data =  @adapter.select("Select type,strftime('%Y', created_at) as year, COUNT (type) As cnt from activities
		Group by type,strftime('%Y', created_at)
		order by cnt asc;")
		erb :activities_group_by_year
	end
	
end


#
# get 'topChildsOf' get top childs grouping by day/month/year
#

def get_top_childs(group_by)

	#set adapter
	@adapter = DataMapper.repository(:default).adapter
	@adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::Underscored

	#set title
	@title = "Top Childs"
	@attribute_name = 'User id '

#if grouping by day
	if (group_by == 'day' )

	@data =  @adapter.select("SELECT Max(cnt) as num_activities,created_at,user_id
			FROM  (Select user_id,created_at, COUNT (user_id) As cnt from activities 
		WHERE parent_or_child = 'child'
		Group by user_id,strftime('%Y', created_at),strftime('%m', created_at),strftime('%d', created_at)
		order by cnt asc)group by strftime('%Y', created_at),strftime('%m', created_at),strftime('%d', created_at);")

	erb :top_by_day

	elsif (group_by == 'month')
		@data =  @adapter.select("SELECT Max(cnt) as num_activities,strftime('%m', created_at)as month , strftime('%Y', created_at) as year,user_id
			FROM (
		Select user_id,created_at, COUNT (user_id) As cnt from activities where parent_or_child = 'child'
		Group by user_id,strftime('%Y', created_at),strftime('%m', created_at)
		order by cnt asc) group by strftime('%Y', created_at),strftime('%m', created_at);")

	erb :top_by_month

	elsif (group_by == 'year')

		@data =  @adapter.select("SELECT Max(cnt) as num_activities,strftime('%Y', created_at) as year,user_id
			FROM (
		Select user_id,created_at, COUNT (user_id) As cnt from activities 
		where parent_or_child = 'child'
		Group by user_id,strftime('%Y', created_at)
		order by cnt asc) group by strftime('%Y', created_at);")

	erb :top_by_year	
	end
end

#
# get 'topParentsOf' get top parents grouping by day/month/year
#

def get_top_parents(group_by)

	#set adapter
	@adapter = DataMapper.repository(:default).adapter
	@adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::Underscored

	#set title
	@title = "Top Parents"
	@attribute_name = 'User id '

	#if grouping by day
	if (group_by == 'day' )

		#execute sql stmt
		@data =  @adapter.select("
			SELECT Max(cnt) as num_activities,created_at,user_id
			FROM  (Select user_id,created_at, COUNT (user_id) As cnt from activities 
			WHERE parent_or_child = 'parent'
			Group by user_id,strftime('%Y', created_at),strftime('%m', created_at),strftime('%d', created_at)
			order by cnt asc)group by strftime('%Y', created_at),strftime('%m', created_at),strftime('%d', created_at);")

	erb :top_by_day

	elsif (group_by == 'month')
		@data =  @adapter.select("SELECT Max(cnt) as num_activities,strftime('%m', created_at)as month , 
			strftime('%Y', created_at) as year,user_id FROM (
			Select user_id,created_at, COUNT (user_id) As cnt from activities where parent_or_child = 'parent'
			Group by user_id,strftime('%Y', created_at),strftime('%m', created_at)
			order by cnt asc) group by strftime('%Y', created_at),strftime('%m', created_at);")

	erb :top_by_month

	elsif (group_by == 'year')

		@data =  @adapter.select("SELECT Max(cnt) as num_activities,strftime('%Y', created_at) as year,user_id FROM (
			Select user_id,created_at, COUNT (user_id) As cnt from activities 
			where parent_or_child = 'parent'
			Group by user_id,strftime('%Y', created_at)
			order by cnt asc) group by strftime('%Y', created_at);")

	erb :top_by_year	
	end

end
