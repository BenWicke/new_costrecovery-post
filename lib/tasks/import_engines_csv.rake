require 'csv'
require 'open-uri'

namespace :import_engines_csv do

	task :create_engines => :environment do
		puts "Import Engines"
	
#		csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/engines.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/engines.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			Engine.create!(row.to_hash.symbolize_keys)
			one_engine = Engine.last
			if @report_timesheet_hash.key?(one_engine.report_nr)
				one_engine.timesheet_id = "#{@report_timesheet_hash[one_engine.report_nr]}"
			end
			
			#one_engine.timesheet_id = @timesheet_id_array[index]
			one_engine.save
		end
    end
end