require 'csv'
require 'open-uri'

namespace :import_command_officers_csv do

	task :create_command_officers => :environment do
		puts "Import Command Officers"
	
		#csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/command_officers.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/command_officers.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			CommandOfficer.create!(row.to_hash.symbolize_keys)
			command_officer = CommandOfficer.last
			if @report_timesheet_hash.key?(command_officer.report_nr)
				command_officer.timesheet_id = "#{@report_timesheet_hash[command_officer.report_nr]}"
			end
			
			#command_officer.timesheet_id = @timesheet_id_array[index]
			command_officer.save
		end
    end
end