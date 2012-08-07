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

#  while true
    @msg = @connection.receive
    #output = @msg.body
    pretty = JSON.parse(@msg.body)

 #   puts JSON.pretty_generate(pretty)

    db = Mongo::Connection.new.db("rail")
    collection = db.collection("td")

    pretty.each do |x| 
 
      puts JSON.pretty_generate(x)   
      id = collection.insert(x)
      puts "total size of collection" + collection.count() + " " +  id + " has " + x 

    end

#  end 

    @connection.disconnect
rescue 
end
