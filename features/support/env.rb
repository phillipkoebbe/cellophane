$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cellophane/main'
require 'rspec/expectations'

Before do
	@initial_dir = Dir.pwd
end

Before('@debug') do
	require 'ruby-debug'
end

After do
	Dir.chdir(@initial_dir)

	# delete the test project directory if present
	FileUtils.remove_dir(@project_dir, true) if @project_dir && File.exist?(@project_dir)
end