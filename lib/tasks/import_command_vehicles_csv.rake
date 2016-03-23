require 'csv'
require 'open-uri'

namespace :import_command_vehicles_csv do

	task :create_command_vehicles => :environment do
		puts "Import Command Vehicles"
	
		#csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/command_vehicles.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/command_vehicles.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			CommandVehicle.create!(row.to_hash.symbolize_keys)
			command_vehicle = CommandVehicle.last
			if @report_timesheet_hash.key?(command_vehicle.report_nr)
				command_vehicle.timesheet_id = "#{@report_timesheet_hash[command_vehicle.report_nr]}"
			end
			
			#command_vehicle.timesheet_id = @timesheet_id_array[index]
			command_vehicle.save
		end
    end
end