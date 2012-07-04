require 'rubygems' 
require 'stomp'

begin
  @user = ENV["DATAFEEDS_USER"]; 
  @password = ENV["DATAFEEDS_PASSWORD"]
  @host = "datafeeds.networkrail.co.uk"
  @port = 61618

  # Example destination
  @destination = "/topic/TD_MC_EM_SIG_AREA"
 
  puts "Connecting to datafeeds as #{@user} using stomp protocol stomp://#{@host}:#{@port}\n" 
  @connection = Stomp::Connection.open @user, @password, @host, @port, true 
  @connection.subscribe @destination 

  while true
    @msg = @connection.receive
    puts @msg 
  end 
  @connection.disconnectionect
rescue 
end
