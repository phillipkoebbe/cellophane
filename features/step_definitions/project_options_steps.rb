Given /^a project specific options file exists in the project root$/ do
	contents = "
		module Cellophane
			class Options
				def self.project_options
		            {
						:cucumber => '--format progress --no-profile'
		            }
				end
			end
		end
	"
	
	# already in the project dir
	File.open('.cellophane.rb', 'w') {|f| f.write(contents) }
end
