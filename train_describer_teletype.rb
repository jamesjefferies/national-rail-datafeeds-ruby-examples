require 'rubygems' 
require 'stomp'
require 'json'
require 'mongo'
require 'active_record'  
require 'mysql2'
require 'pusher'

Pusher.app_id = '25850'
Pusher.key = '3a053988aaed74f037eb'
Pusher.secret = '809d36326d9d2aebc982'

ActiveRecord::Base.establish_connection(  :adapter=> "mysql",  :host => "localhost",  :database=> "nrdata", :username=> "root", :password=> "password", :adapter => "mysql2")  
                                         
class Location < ActiveRecord::Base  
  self.table_name = 'location_data'
end  

=begin
mysql> select * from location_data where location like '%Congleton%';
+------+------------------------------------+------+--------+---------+--------+
  | id   | location                           | crs  | nlc    | tiploc  | stanox |
  +------+------------------------------------+------+--------+---------+--------+
  | 2638 | Congleton                          | CNG  | 122700 | CONGLTN | 43013  |
  | 2639 | Congleton Civil Engineer's Sidings |      | 122713 | CONGCE  | 43012  |
  +------+------------------------------------+------+--------+---------+--------+
=end

def numeric?(object)
    true if Float(object) rescue false
end

class TrainDescriber
  attr_accessor :time, :location, :headcode

  def to_s
    "#{@time} Train: #{@headcode} is at #{@location}"
  end
end

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
    coll = db.collection("berthsteps")

    # Example berth step
    # {"to"=>"6556", "time"=>"1344954186000", "area_id"=>"R2", "msg_type"=>"CA", "from"=>"6558", "descr"=>"2G50"}

    message_body.each do |td| 

      # Note td is a hash, with key being the message, i.e. CA_MSG
      if td.has_key?("CA_MSG")

        t = TrainDescriber.new          

        thismsg = td.fetch("CA_MSG")
        time = "Unknown" 
        # puts "Headcode: " + thismsg.fetch("descr")
       
        t.headcode = thismsg.fetch("descr") 
        # puts thismsg.to_s
       
        begin
          thistime = (thismsg.fetch("time", "1344954186000").to_i / 1000)
          time = Time.at(thistime)
          t.time = time
        rescue Exception 
          print "Boom bang bang #{$!}"  
        end

        from = thismsg.fetch("from")

        from_berth_step = coll.find_one({ "from_berth" => "#{from}"  })

        # Example from berth step from poggs data
        #
        # {"_id"=>BSON::ObjectId('502b5a7df49d04d930003309'), "td_area"=>"SK", "step_type"=>"B", "from_berth"=>"3639", "to_berth"=>"3643", "stanox"=>"42302", "stanme"=>"MADELEY", "event"=>"D", "platform"=>"", "line"=>"F", "trust_berth_offset"=>"11", "route"=>"2", "description"=>"21-09-09"}

        unless from_berth_step.nil?
          stanox = from_berth_step.fetch("stanox")
          location_data =  Location.where("stanox = ?", stanox).first
          t.location = location_data.location
        end

        # Temporary way of getting location!
        #  open('AllBerthSteps_2012-06.csv') do |f| 
        #    puts f.grep(/#{from}/) 
        #  end       
        data = {
          'id' => @id,
          'body' => t.to_s, #Set this to be the headcode and location
          'published' => t.time, #Set this to be the string containing the date
          'type' => @type,
        }

        puts t.to_s
        Pusher['site-activity'].trigger('activity', data)

      end
    end
  end 

  @connection.disconnect
rescue Exception 
  print "Boom bang bang #{$!}"  
end
