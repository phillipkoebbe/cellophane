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

Given /^Cellophane is called with no arguments$/ do
	call_cellophane
end

Given /^a (typical|custom) project directory$/ do |project_type|
	@project_dir = './test_project'
	FileUtils.mkdir(@project_dir)
	Dir.chdir(@project_dir)

	if project_type == 'typical'
		@feature_dir = "features"
		@step_dir = "#{@feature_dir}/step_definitions"
		FileUtils.mkdir_p(@step_dir)
	else
		@feature_dir = "cuke/features"
		@step_dir = "cuke/steps"
		@support_dir = "cuke/support"
		[@project_dir, @feature_dir, @step_dir, @support_dir].each { |dir| FileUtils.mkdir_p(dir) }
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

