Given /^I debug$/ do
	require 'ruby-debug'
	debugger
	puts "\n\ndebugging\n\n"
end

Given /^Cellophane is called with "([^"]*)"$/ do |args|
	call_cellophane(args.split(' '))
end

Given /^the (command|message) should include "([^"]+)"$/ do |what, expected|
	(what == 'command' ? @command : @message).should =~ /#{expected}/
end

Given /^the (command|message) should not include "([^"]+)"$/ do |what, expected|
	(what == 'command' ? @command : @message).should_not =~ /#{expected}/
end

Given /^a project directory with the following structure$/ do |structure|
	@project_dir = './test_project'
	# just in case the last run failed to exit cleanly, delete the test_project directory
	# if it exists
	FileUtils.remove_dir(@project_dir, true) if File.exist?(@project_dir)
	FileUtils.mkdir(@project_dir)
	Dir.chdir(@project_dir)
	
	structure.hashes.each do |entry|
		if entry[:type] == 'directory'
			FileUtils.mkdir_p(entry[:path])
		else
			File.open(entry[:path], 'w') {|f| f.write("# #{entry[:path]}") }
		end
	end
end

Given /^a project options file with the following options$/ do |lines|
	options = lines.hashes.collect { |line| line[:option] }
	
	contents = "
		module Cellophane
			class Options
				def self.project_options
		            {
						#{options.join(",\n")}
		            }
				end
			end
		end
	"
	
	# already in the project dir
	File.open('.cellophane.rb', 'w') {|f| f.write(contents) }
end