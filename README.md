
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

*browser used : chrome*