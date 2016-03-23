#require 'csv'

#namespace :import_mat_lists_csv do

#	task :create_mat_lists => :environment do
#		puts "Import Material List"
	
#		csv_text = File.read('c:/rails/thumb/costrecovery/lib/csv_import/mat_lists.csv')
#		csv = CSV.parse(csv_text, :headers => true)
#		csv.each_with_index do |row,index|
#			row = row.to_hash.with_indifferent_access
#			MatList.create!(row.to_hash.symbolize_keys)
#			matlist = MatList.last
#			matlist.incident_id = @incident_id_array[index]
#			matlist.save
#		end
		
		
		
#    end
#end



require 'csv'
require 'open-uri'

namespace :import_mat_lists_csv do

	task :create_mat_lists => :environment do
		puts "Import Material List"
		#csv_text = File.read('http://www.ciagent-stormwater.com/Lexington_Files/mat_lists.csv', :encoding => 'windows-1251:utf-8')
    csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/mat_lists.csv") {|f| f.read}
		csv = CSV.parse(csv_text, :headers => true)
		csv.each_with_index do |row,index|
			row = row.to_hash.with_indifferent_access
			MatList.create!(row.to_hash.symbolize_keys)
			matlist = MatList.last
			if @report_incident_hash.key?(matlist.report_nr)
				matlist.incident_id = "#{@report_incident_hash[matlist.report_nr]}"
			end
			
			#matlist.incident_id = @timesheet_id_array[index]
			matlist.save
		end
    end
end






