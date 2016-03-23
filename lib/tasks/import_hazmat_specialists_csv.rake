require 'csv'
require 'open-uri'

namespace :import_hazmat_specialists_csv do

	task :create_hazmat_specialists => :environment do
		puts "Import Hazmat Specialists"
	
#		csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/hazmat_specialists.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/hazmat_specialists.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			HazmatSpecialist.create!(row.to_hash.symbolize_keys)
			hazmat_specialist = HazmatSpecialist.last
			if @report_timesheet_hash.key?(hazmat_specialist.report_nr)
				hazmat_specialist.timesheet_id = "#{@report_timesheet_hash[hazmat_specialist.report_nr]}"
			end
			
			#hazmat_specialist.timesheet_id = @timesheet_id_array[index]
			hazmat_specialist.save
		end
    end
end