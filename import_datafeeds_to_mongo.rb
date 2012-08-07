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
  @destination = "/topic/TRAIN_MVT_ALL_TOC"

  puts "Connecting to datafeeds as #{@user} using stomp protocol stomp://#{@host}:#{@port}\n" 
  @connection = Stomp::Connection.open @user, @password, @host, @port, true 
  @connection.subscribe @destination 

  while true
    @msg = @connection.receive

    # Use JSON library to parse the messge body
    message_body = JSON.parse(@msg.body)

    db = Mongo::Connection.new.db("rail")
    coll = db.collection("td")

    message_body.each do |td| 

      # Sanity check debug, output each td message as nice looking JSON 
      # puts JSON.pretty_generate(td)   
      
      # insert into collection
      id = coll.insert(td)

    end
  end 

  @connection.disconnect
rescue 
end
