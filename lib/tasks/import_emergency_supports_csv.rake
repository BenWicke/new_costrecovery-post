require 'csv'
require 'open-uri'

namespace :import_emergency_supports_csv do

	task :create_emergency_supports => :environment do
		puts "Import Emergency Supports"
	
#		csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/emergency_supports.csv', :encoding => 'windows-1251:utf-8')
		csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/emergency_supports.csv") {|f| f.read}
    csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			EmergencySupport.create!(row.to_hash.symbolize_keys)
			emergency_support = EmergencySupport.last
			if @report_timesheet_hash.key?(emergency_support.report_nr)
				emergency_support.timesheet_id = "#{@report_timesheet_hash[emergency_support.report_nr]}"
			end
			
			#emergency_support.timesheet_id = @timesheet_id_array[index]
			emergency_support.save
		end
    end
end