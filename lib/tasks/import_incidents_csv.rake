require 'csv'
require 'open-uri'


namespace :import_incidents_csv do

	task :create_incidents => :environment do
		puts "Import Incidents"

		
		#csv_text = File.read('/Users/Ben/Sites/ror/LFD/incidents.csv', :encoding => 'windows-1251:utf-8')
		
		csv_text = open("http://www.ciagent-stormwater.com/irst/lexington/incidents.csv") {|f| f.read}
    csv = CSV.parse(csv_text, :headers => true)
		
		@incident_id_array = []
		@report_nr_array = []
		csv.each do |row|
			row = row.to_hash.with_indifferent_access
			Incident.create!(row.to_hash.symbolize_keys)
			@incident_id_array << Incident.last.id
			@report_nr_array << Incident.last.report_nr
		end
		
#------This combines the incidents array and the report_nr array into a hash
		
		@report_incident_hash = {}
		@report_nr_array.each_with_index do |value, index|
			@report_incident_hash[value] = @incident_id_array[index]
		end
		#puts @report_incident_hash
#----------------------------------------------------------------------------
		
   end
end