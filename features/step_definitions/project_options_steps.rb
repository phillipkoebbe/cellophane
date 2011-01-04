def project_options_file_contents
	"
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
end

def create_project_options_file(path)
	File.open("#{path}/.cellophane.rb", 'w') {|f| f.write(project_options_file_contents) }
end

Given /^a project specific options file exists in the project root$/ do
	# already in the project dir
	create_project_options_file('.')
end

Given /^the command should include the project specific options$/ do
	@command.should =~ /--format progress --no-profile/
end
