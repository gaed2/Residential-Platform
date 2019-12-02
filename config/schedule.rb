# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
# #
# set :output, "log/cron_log.log"
# #
# # every 2.hours do
# #   command "/usr/bin/some_great_command"
# #   runner "MyModel.some_method"
# #   rake "some:great:rake:task"
# # end
# #
# # every 4.days do
# #   runner "AnotherModel.prune_old_records"
# # end

# # Learn more: http://github.com/javan/whenever

# every 1.hour do
#   # collect all the records whose status is not uploaded
# end

=begin

 create a json with the data of user
- convert the into sha 256 encrypted form
- store in the db with a attached new uuid


- Upload the image/pdf
- convert image/pdf to sha 256
- map with uuid , image/pdf url , attachment type

table()
 id: integer
 uuid: uuid
 data_hash: string ( encrypted hash )
 data_type: string ( user_data, image, pdf )
 data_url: string ( for image/ pdf )
 status: enum ( inprogress, success , failed, timeout )
 deleted_at: time_stamp
 property_id: integer



 Cron jobs
  - every hour collect all the records from table whoes status is [inprogress, failed]
  - check http://localhost:3001/shas/282a4187-fcf0 , verify hash with our table
  - update the record to success if the data is updated ( poll every 10 sec )
  - failed records should be run 3 times for every one hour, if did not succeed again update status timeout

Property
 status sent_to_blockchain, awating


=end


# Update the status to the property table record ( awaiting_to_send, updated_to_block, timeout)

# Background jobs

# JOB1

#  - To create block chain data
#   - Create a file of json data upload it to gcloud
#   - update data url
#   - for images and pdf, data url will be taken from model attribute


# JOB 2 ( hourly )
# - recurring job to check every hour from the property table whoes status is awaiting_to_send
# - get the property_id
# - hit post API ( of block chain ) to update to the block chain
# - update the status as inprogress

# JOB 3 ( hourly )
#  - poll every 5 seconds to see of the data is sucessfully send to block chain
#  - Use GET api of block chain
#  - update the status as updated_to_block to property
#  - update the status as success to the blockchain_data table
#  - if the job failed three times ( successfully 3 times), update the status as failed


# JOB 4 ( hourly )
#  - get the jobs of failed status
#  - if the count is more than 3 failed , update the status to the job as timeout
#   - update the status of property as timeout


# update record job
#  - update the status of property as awaiting_to_send
#  - update delted_at field to true
#  - continue as job 1


# admin account count
 # 10
# Robstern account or main account

# require 'fog'

# # create a connection
# connection = Fog::Storage.new({
#   :provider                 => 'Google',
#   :aws_access_key_id        => 'GOOGCERWSRM3CU22JDP3QQDF',
#   :aws_secret_access_key    => 'kVS54c03LbtkgYLFwZDoN3bP+rW54Hdhc7R2AtRo',
#   :google_project           => 'gaed-keeper'
# })

# # First, a place to contain the glorious details
# directory = connection.directories.create(
#   :key    => "fog-demo-#{Time.now.to_i}", # globally unique name
#   :public => true
# )

# # list directories
# p connection.directories

# # upload that resume
# file = directory.files.create(
#   :key    => 'resume.html',
#   :body   => File.open("/path/to/my/resume.html"),
#   :public => true
# )

#   FOG_PROVIDER: fog/google
#   PROVIDER: Google
#   ACCESS_KEY: 'GOOGCERWSRM3CU22JDP3QQDF'
#   SECRET_KEY: 'kVS54c03LbtkgYLFwZDoN3bP+rW54Hdhc7R2AtRo'



#   Fog::Storage::Google.new(:google_project => 'gaed-keeper', :google_client_email => '89336053795-compute@developer.gserviceaccount.com', :google_json_key_location => 'gaed-keeper-860eeed496c1.json')

#   'gaedkeeper-bucket'

# notasecret


# require 'open-uri'
# download = open('https://storage.googleapis.com/gaedkeeper-bucket/uploads/user/avatar/5/thumb_images.jpeg')
# IO.copy_stream(download, 'image.png')


# Fog::Storage::Google.new(google_project: )