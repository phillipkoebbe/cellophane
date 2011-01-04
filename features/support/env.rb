$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cellophane/main'
require 'rspec/expectations'

Before do
	@initial_dir = Dir.pwd
end

After do
	Dir.chdir(@initial_dir)
	return if @project_dir.nil?

	# delete the test project directory if present
	FileUtils.remove_dir(@project_dir, true) if File.exist?(@project_dir)
end