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
