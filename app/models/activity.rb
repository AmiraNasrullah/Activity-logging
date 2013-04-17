# == Schema Information
#
# Table name: Activity
#
#  id       		 :integer          primary key
#  user_id   		 :integer          
#  parent_or_child 	 :String           required
#  created_at		 :datetime         required
#  description		 :Text	            		
#  type       		 :String		    required
#

class Activity
	include DataMapper::Resource

	#Attributes
	property :id, Serial
	property :user_id, Integer, :required => true
	property :parent_or_child, String, :required => true
	property :type, String, :required => true
	property :description, Text
	property :created_at, Date, :required => true
	property :created_at_time, DateTime, :required => true

	#
	#convert Activity to json format
	#
	def to_json(*a)
    { 
      'id'                => self.id,
      'user_id'           => self.user_id,
      'parent_or_child'   => self.parent_or_child,
      'description'       => self.description,
      'type'    	      => self.type,
      'created_at'        => self.created_at, 
      'created_at_time'   =>created_at_time,
    }.to_json(*a)
  end

end