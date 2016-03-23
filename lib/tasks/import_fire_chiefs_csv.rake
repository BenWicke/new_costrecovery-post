require 'csv'
require 'open-uri'

namespace :import_fire_chiefs_csv do

	task :create_fire_chiefs => :environment do
		puts "Import Fire Chiefs"
	
#		csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/fire_chiefs.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/fire_chiefs.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			FireChief.create!(row.to_hash.symbolize_keys)
			fire_chief = FireChief.last
			if @report_timesheet_hash.key?(fire_chief.report_nr)
				fire_chief.timesheet_id = "#{@report_timesheet_hash[fire_chief.report_nr]}"
			end
			
			#fire_chief.timesheet_id = @timesheet_id_array[index]
			fire_chief.save
		end
    end
end