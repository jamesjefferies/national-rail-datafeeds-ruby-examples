# Copyright 2012 James Jefferies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
#
require 'rubygems' 
require 'stomp'
require 'json'
require 'mongo'

begin
  # Credentials set here as environment variables
  @user = ENV["DATAFEEDS_USER"]; 
  @password = ENV["DATAFEEDS_PASSWORD"]
  @host = "datafeeds.networkrail.co.uk"
  @port = 61618

  # Example destination add yours here
  @destination = "/topic/TD_ALL_SIG_AREA"

  puts "Connecting to datafeeds as #{@user} using stomp protocol stomp://#{@host}:#{@port}\n" 
  @connection = Stomp::Connection.open @user, @password, @host, @port, true 
  @connection.subscribe @destination 

  while true
    @msg = @connection.receive

    # Use JSON library to parse the messge body
    message_body = JSON.parse(@msg.body)

    db = Mongo::Connection.new.db("rail")
    coll = db.collection("traindescriber")

    message_body.each do |td| 

      # insert into collection
      id = coll.insert(td)
      
      # Sanity check debug, output each td message as nice looking JSON 
      #puts JSON.pretty_generate(td)   
      #puts "inserted with id " + id.to_s;

    end
  end 

  @connection.disconnect
rescue 
end
