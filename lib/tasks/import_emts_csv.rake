require 'csv'
require 'open-uri'

namespace :import_emts_csv do

	task :create_emts => :environment do
		puts "Import EMTS"
	
		#csv_text = File.read('/Users/Ben/Sites/ror/LFD/emts.csv', :encoding => 'windows-1251:utf-8')
		csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/emts.csv") {|f| f.read}
    csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			Emt.create!(row.to_hash.symbolize_keys)
			one_emt = Emt.last
			if @report_timesheet_hash.key?(one_emt.report_nr)
				one_emt.timesheet_id = "#{@report_timesheet_hash[one_emt.report_nr]}"
			end
			
			#one_emt.timesheet_id = @timesheet_id_array[index]
			one_emt.save
		end
    end
end

