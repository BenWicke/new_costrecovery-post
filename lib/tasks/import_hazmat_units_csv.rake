require 'csv'
require 'open-uri'

namespace :import_hazmat_units_csv do

	task :create_hazmat_units => :environment do
		puts "Import Hazmat Units"
	
#		csv_text = File.read('/Users/Ben/Sites/ror/LFD/hazmat_units.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/hazmat_units.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			HazmatUnit.create!(row.to_hash.symbolize_keys)
			hazmat_unit = HazmatUnit.last
			if @report_timesheet_hash.key?(hazmat_unit.report_nr)
				hazmat_unit.timesheet_id = "#{@report_timesheet_hash[hazmat_unit.report_nr]}"
			end
			
			#hazmat_unit.timesheet_id = @timesheet_id_array[index]
			hazmat_unit.save
		end
    end
end