require 'optparse'

module Cellophane
	class Options
		def self.parse(args)
			merged_options = self.get_options(:default).merge(self.get_options(:project))
			
			option_parser = OptionParser.new do |opts|
				# Set a banner, displayed at the top of the help screen.
				# TODO add example usage including ~feature, patterns, and ~tag
				opts.banner = "Usage: cellophane [options] PATTERN"

				opts.on('-r', '--regexp', 'PATTERN is a regular expression. Default is false.') do
					merged_options[:regexp] = true
				end
				
				opts.on('-t', '--tags TAGS', 'Tags to include/exclude.') do |tags|
					merged_options[:tags] = tags
				end

				opts.on('-c', '--cucumber OPTIONS', 'Options to pass to cucumber.') do |cucumber|
					merged_options[:cucumber] = cucumber
				end
	
				opts.on('-p', '--print', 'Echo the command instead of calling cucumber.') do
					merged_options[:print] = true
				end

				opts.on('-d', '--debug', 'Require ruby-debug.') do
					require 'rubygems'
					require 'ruby-debug'
				end

				# This displays the help screen, all programs are assumed to have this option.
				opts.on( '-h', '--help', 'Display this screen.' ) do
					puts opts
					exit(0)
				end
			end

			option_parser.parse!(args)
			
			# get the pattern from the command line (no switch)
			merged_options[:pattern] = args.first if args.any?

			return self.normalize_options(merged_options)
		end # self.parse
		
		private
		
		def self.get_options(type = :default)
			if type == :project
				project_options_file = "./.cellophane.rb"
				
				# load is used here due to require not requiring a file if
				# it has already been required. This is mainly for testing
				# purposes (multiple features needing to have different
				# options for validation), but it shouldn't make a difference
				# for run time.
				load project_options_file if File.exist?(project_options_file)

				self.respond_to?(:project_options) ? self.project_options : {}
			else
				{
					:pattern => nil,
					:regexp => false,
					:print => false,
					:cucumber => nil,
					:tags => nil,
					:feature_path => 'features',
					:feature_path_regexp => nil,
					:step_path => 'features/step_definitions',
					:requires => []
				}
			end
		end # get_options
		
		def self.normalize_options(options)
			defaults = self.get_options(:default)

			# ran into freezing problems in Ruby 1.9.2 otherwise
			tmp_options = options.dup
			
			paths = [:feature_path]
			
			# options[:steps] might look like {:nested => 'dirname'} to indicate the steps
			# are nested under the feature directory (see documentation)
			paths << :step_path unless tmp_options[:step_path].is_a?(Hash)
			
			# normalize the paths for features and steps
			paths.each do |path|
				# had originally used the gsub! and sub!, but hit freezing problems with Ruby 1.9.2
				# globs don't work with backslashes (if on windows)
				tmp_options[path] = tmp_options[path].gsub(/\\/, '/')
				
				# strip trailing slash
				tmp_options[path] = tmp_options[path].sub(/\/$/, '')
			end
			
			# need to know this later
			tmp_options[:non_standard_feature_path] = tmp_options[:feature_path] != defaults[:feature_path]
			tmp_options[:non_standard_step_path] = tmp_options[:step_path] != defaults[:step_path]
			
			# make a regexp out of the features path if there isn't one already. we need to escape slashes so the
			# regexp can be made
			tmp_options[:feature_path_regexp] = Regexp.new(tmp_options[:feature_path].gsub('/', '\/')) unless tmp_options[:feature_path_regexp]
			
			# just in case someone sets necessary values to nil, let's go back to defaults
			tmp_options[:regexp] ||= defaults[:regexp]
			tmp_options[:feature_path] ||= defaults[:feature_path]
			tmp_options[:step_path] ||= defaults[:step_path]
			tmp_options[:requires] ||= defaults[:requires]
			
			# do what needs to be done on the pattern
			unless tmp_options[:pattern].nil?
				tmp_options[:pattern] = tmp_options[:pattern].strip
				tmp_options[:pattern] = nil unless tmp_options[:pattern] && !tmp_options[:pattern].empty?
			
				begin
					tmp_options[:pattern] = Regexp.new(tmp_options[:pattern]) if tmp_options[:regexp]
				rescue
					# if the regexp fails for some reason
					tmp_options[:pattern] = nil
				end
			end
			
			return tmp_options
		end # normalize_options
	end # class Options
end