Given /^a project specific option file defining the custom paths$/ do
	contents = "
		module Cellophane
			class Options
				def self.project_options
		            {
						:feature_path => 'cuke/features',
						:step_path => 'cuke/steps'
		            }
				end
			end
		end
	"
	
	# already in the project dir
	File.open('.cellophane.rb', 'w') {|f| f.write(contents) }
end

