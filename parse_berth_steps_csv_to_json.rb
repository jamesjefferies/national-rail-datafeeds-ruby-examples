require 'csv'
require 'json'
=begin

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
# event,details,gender,day,date,starttime,endtime,duration,venue

# td_area,step_type,from_berth,to_berth,stanox,stanme,event,platform,line,trust_berth_offset,route,line,description
#
AD,B,0632,0630,89321,PLUCKLY,A,1,,24,,,08-05-2012
AD,B,0630,0628,89321,PLUCKLY,B,1,,-56,1,,08-05-2012
AD,B,0631,0633,89321,PLUCKLY,C,2,,25,,,08-05-2012
AD,B,0633,0635,89321,PLUCKLY,D,2,,-51,2,,08-05-2012
AD,B,ET09,ET05,89641,CTPORTLGB,B,,,0,1,,Migrated on 8/6/2005
AD,B,ET09,ET04,89641,CTPORTLGB,B,,,0,1,,Migrated on 8/6/2005
AD,B,ET50,ET04,89641,CTPORTLGB,B,,,0,1,,Migrated on 8/6/2005
=end

FILENAME="AllBerthSteps_2012-06.csv"
HEADER = ['td_area','step_type','from_berth','to_berth','stanox','stanme','event','platform','line','trust_berth_offset','route','line','description']

csv_data = CSV.read FILENAME

headers = HEADER.map {|i| i.to_s }
string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }

puts array_of_hashes
