
*-------------------------------ACTIVITY LOGGING------------------------------*


This example code has a simple API for creating, updating and deleting 'Activities'.
To run app : 

Activity table attributes :

*user_id : id for user
*parent_or_child : if user is parent or child
*type : activity type ex: Assign a task, Give balloons , finish a task.....
*description : more details about activity
*created_at : Date and time when this user do this activity


rackup config.ru


*Add a Activity to the database:*

url => http://localhost:4567/

example : 
*put 

	user id = 5
	parent or child = parent
	type = Give balloons 
	description = Give 50 balloons to Ahmad

*enter log activity!
*put 

	user id = 5
	parent or child = parent
	type = Assign a task 
	description = Assign say Thanks to Eman

*enter log activity!

*get activities for specific user *

url => http://localhost:4567/user/:user_id

example :

url => http://localhost:4567/user/5


*---------------------------------SECOND TASK------------------------------------*

*Statistics reporting :-

	*get how many activities of each type 
			group by day => 'http://localhost:4567/activities/day'
			group by month => 'http://localhost:4567/activities/month'
			group by year => 'http://localhost:4567/activities/year'


*top parents :-

	get top parents of day => 'http://localhost:4567/topParentsOf/day'
	get top parents of year => 'http://localhost:4567/topParentsOf/year'
	get top parents of month => 'http://localhost:4567/topParentsOf/month'


*top Childs :-

	get top parents of day => 'http://localhost:4567/topChildsOf/day'
	get top parents of year => 'http://localhost:4567/topChildsOf/year'
	get top parents of month => 'http://localhost:4567/topChildsOf/month'


*browser used : chrome*