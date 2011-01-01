require 'optparse'
require "#{ENV['HOME']}/.cellophane.rb" if File.exists?("#{ENV['HOME']}/.cellophane.rb")
require '.cellophane.rb' if File.exist?('.cellophane.rb')

module Cellophane
	class Configuration
		def options
			merged_options = get_options(:default).merge(get_options(:user)).merge(get_options(:project))
			
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
	
				opts.on('-d', '--dry-run', 'Echo the command instead of calling cucumber.') do
					merged_options[:dry_run] = true
				end

				# This displays the help screen, all programs are assumed to have this option.
				opts.on( '-h', '--help', 'Display this screen.' ) do
					puts opts
					exit
				end
			end

			# Parse the command-line. Remember there are two forms
			# of the parse method. The 'parse' method simply parses
			# ARGV, while the 'parse!' method parses ARGV and removes
			# any options found there, as well as any parameters for
			# the options. What's left is the list of files to resize.
			option_parser.parse!
			
			# get the pattern from the command line (no switch)
			merged_options[:pattern] = ARGV.at(0) if ARGV.size > 0

			return normalize_options(merged_options)
		end # self.options
		
		private
		
		def get_options(type = :default)
			case type
				when :user
					self.respond_to?(:user_options) ? self.user_options : {}
				when :project
					self.respond_to?(:project_options) ? self.project_options : {}
				else
					{
						:pattern => nil,
						:regexp => false,
						:dry_run => false,
						:cucumber => nil,
						:tags => nil,
						:feature_path => 'features',
						:feature_path_regexp => nil,
						:step_path => 'features/step_definitions',
						:requires => []
					}
			end # case type
		end # get_options
		
		def normalize_options(options)
			paths = [:feature_path]
			
			# options[:steps] might look like {:nested => 'dirname'} to indicate the steps
			# are nested under the feature directory (see documentation)
			paths << :step_path unless options[:step_path].is_a?(Hash)
			
			# normalize the paths for features and steps
			paths.each do |path|
				# globs don't work with backslashes (if on windows)
				options[path].gsub!(/\\/, '/')
			
				# strip trailing slash
				options[path].sub!(/\/$/, '')
			end
			
			# make a regexp out of the features path if there isn't one already. we need to escape slashes so the
			# regexp can be made
			options[:feature_path_regexp] = Regexp.new(options[:feature_path].gsub('/', '\/')) unless options[:feature_path_regexp]
			
			# just in case someone sets necessary values to nil, let's go back to defaults
			defaults = get_options(:default)
			options[:regexp] ||= defaults[:regexp]
			options[:feature_path] ||= defaults[:feature_path]
			options[:step_path] ||= defaults[:step_path]
			options[:requires] ||= defaults[:requires]
			
			# do what needs to be done on the pattern
			unless options[:pattern].nil?
				options[:pattern].strip!
				options[:pattern] = nil if options[:pattern].empty?
			
				begin
					options[:pattern] = Regexp.new(options[:pattern]) if options[:regexp]
				rescue
					# if the regexp fails for some reason
					options[:pattern] = nil
				end
			end
			
			return options
		end # normalize_options
	end # class Configuration
end