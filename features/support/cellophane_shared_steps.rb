def call_cellophane(args = [])
	cellophane = Cellophane::Main.new(args)
	@command = cellophane.command
	@message = cellophane.message
end

def output_command
	puts "\n\n#{@command}\n\n"
end

def output_message
	puts "\n\n#{@message}\n\n"
end

Given /^Cellophane is called with "([^"]*)"$/ do |args|
	call_cellophane(args.split(' '))
end

Given /^a (standard|non-standard) project directory$/ do |project_type|
	@project_dir = './test_project'
	# just in case the last run failed to exit cleanly, delete the test_project directory
	# if it exists
	FileUtils.remove_dir(@project_dir, true) if File.exist?(@project_dir)
	FileUtils.mkdir(@project_dir)
	Dir.chdir(@project_dir)

	if project_type == 'standard'
		@feature_dir = "features"
		@step_dir = "#{@feature_dir}/step_definitions"
		FileUtils.mkdir_p(@step_dir)
	else
		@feature_dir = "cuke/features"
		@step_dir = "cuke/steps"
		@support_dir = "cuke/support"
		[@feature_dir, @step_dir, @support_dir].each { |dir| FileUtils.mkdir_p(dir) }
	end

	# make some features
	File.open("#{@feature_dir}/one.feature", 'w') {|f| f.write('Feature: One') }
	File.open("#{@feature_dir}/two.feature", 'w') {|f| f.write('Feature: Two') }
	File.open("#{@feature_dir}/three.feature", 'w') {|f| f.write('Feature: Three') }
	File.open("#{@feature_dir}/four.feature", 'w') {|f| f.write('Feature: Four') }
	
	# make some steps
	File.open("#{@step_dir}/one_steps.rb", 'w') {|f| f.write('# One steps') }
	File.open("#{@step_dir}/four_steps.rb", 'w') {|f| f.write('# Four steps') }
end

Given /^the (command|message) should include "([^"]+)"$/ do |what, expected|
	(what == 'command' ? @command : @message).should =~ /#{expected}/
end

Given /^the (command|message) should not include "([^"]+)"$/ do |what, expected|
	(what == 'command' ? @command : @message).should_not =~ /#{expected}/
end
