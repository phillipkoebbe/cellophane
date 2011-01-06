$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cellophane/main'
require 'rspec/expectations'

Before do
	save_initial_dir
	ensure_project_dir_removed
end

Before('@debug') do
	require 'ruby-debug'
end

After do
	restore_initial_dir
	ensure_project_dir_removed
end