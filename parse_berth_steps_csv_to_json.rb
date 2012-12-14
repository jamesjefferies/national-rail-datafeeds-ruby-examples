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
require 'csv'
require 'json'
require 'mongo'
=begin

Info from http://http://wiki.openraildata.info/index.php/TD_Berth_Steps

TD area ID, as per the list of TD area codes
Step type - 'B' = Between, 'F' = From, 'T' = To, 'D' = Inter First, 'C' = Clearout, 'I' = Interpose, 'E' = Inter Last
From berth
To berth
STANOX
STANME
Event - 'A' = Arrival in the Up direction, 'B' = Departure in the Up direction, 'C' = Arrival in the Down direction, 'D' = Departure in the Down direction
Platform
Line
TRUST berth offset
Route
Line
Description (not populated with useful text)

# Example header
# td_area,step_type,from_berth,to_berth,stanox,stanme,event,platform,line,trust_berth_offset,route,line,description

# Example data
AD,B,0632,0630,89321,PLUCKLY,A,1,,24,,,08-05-2012
=end

FILENAME="AllBerthSteps_2012-06.csv"

# You might want to change this, easily done
HEADER = ['td_area','step_type','from_berth','to_berth','stanox','stanme','event','platform','line','trust_berth_offset','route','line','description']

csv_data = CSV.read FILENAME

headers = HEADER.map {|i| i.to_s }
string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

# Assume mongo database is called rail (or it will create one if it doesn't exist)
db = Mongo::Connection.new.db("rail")

# Create/use collection called berthsteps
coll = db.collection("berthsteps")

array_of_hashes.each do |td| 

  # Sanity check debug, output each td message as nice looking JSON 
  #puts JSON.pretty_generate(td)   
      
  # insert into collection and return with the id 
  id = coll.insert(td)

end
