require 'fileutils'
require 'cellophane/parser'
require 'cellophane/options'

module Cellophane
	
	VERSION = '0.1.3'
	PROJECT_OPTIONS_FILE = '.cellophane.yaml'
	
	class Main
		attr_reader :command, :message, :project_options_file
		
		def initialize(args = nil)
			args ||= ARGV
			@project_options_file = Cellophane::PROJECT_OPTIONS_FILE
			@options = Cellophane::Options.parse(args)
			
			@message = 'Invalid regular expression provided.' and return if @options[:regexp] && @options[:pattern].nil?
			
			parser = Cellophane::Parser.new(@options)
			@features = parser.features
			
			@message = 'No features matching PATTERN were found.' and return unless @features
			
			@tags = parser.tags
			
			@command = generate_command
		end

		def run
			puts @message and return if @message
			@options[:print] || @options[:version] ? puts(@command) : system("#{@command}\n\n")
		end
		
		private
		
		def generate_command
			return "cellophane #{Cellophane::VERSION}" if @options[:version]
			
			cuke_cmd = "#{@options[:cuke_command]} #{@options[:cucumber]}"

			features = []
			steps = []

			if @features.any?
				@features.each do |file|
					file_parts = split_feature(file)
					features << construct_feature_file(file_parts[:path], file_parts[:name])
					steps += search_for_step_files(file_parts[:path], file_parts[:name])
				end
			else
				# if there are no features explicitly identified, then cucumber will run all. However,
				# if we are using non-standard locations for features or step definitions, we must tell
				# cucumber accordingly
				features << @options[:feature_path] if @options[:non_standard_feature_path]
				steps << @options[:step_path] if @options[:non_standard_step_path]
			end

			requires = (@options[:requires] + steps).compact.uniq
			cuke_cmd += " -r #{requires.join(' -r ')}" if requires.any?
			cuke_cmd += " #{features.join(' ')}" if features.any?
			return "#{cuke_cmd} #{@tags}".gsub('  ', ' ')
		end
		
		def construct_feature_file(path, file)
			"#{@options[:feature_path]}/#{path}/#{file}.feature".gsub('//', '/')
		end
		
		def search_for_step_files(path, file)
			steps = []
			
			steps_nested = @options[:step_path].is_a?(Hash)
			nested_path = "#{@options[:feature_path]}/#{path}/#{@options[:step_path][:nested_in]}" if steps_nested
			non_nested_path = "#{@options[:step_path]}/#{path}" unless steps_nested
			
			step_path = steps_nested ? nested_path : non_nested_path
			step_file = "#{step_path}/#{file}_steps.rb".gsub('//', '/')
			steps << step_file if File.exist?(step_file)

			# now lets see if we need to load shared step files
			
			if @options[:shared]
				if steps_nested
					step_file = "#{step_path}/#{@options[:shared]}_steps.rb".gsub('//', '/')
					steps << step_file if File.exist?(step_file)
				else
					# don't want to look in the directories that make up the step root
					step_path.sub!(@options[:step_path_regexp], '')
					
					# make an array of the parts of the path that remain
					step_path_parts = step_path.split('/')
				
					# if there are any unnecessary slashes, step_path_parts will have empty elements...get rid of them
					step_path_parts.delete_if { |part| (part || '').strip.empty? }
					
					# for each path, look for a shared step file
					while step_path_parts.any? do
						step_file = "#{@options[:step_path]}/#{step_path_parts.join('/')}/#{@options[:shared]}_steps.rb"
						steps << step_file if File.exist?(step_file)
					
						# get rid of the last path part
						step_path_parts.pop
					end
					
					# now look in the step path root
					step_file = "#{@options[:step_path]}/#{@options[:shared]}_steps.rb"
					steps << step_file if File.exist?(step_file)
				end # steps are not netsted
			end # if @options[:shared]

			return steps
		end # search_for_step_files
		
		def split_feature(file)
			name = File.basename(file, '.feature')
			# now get rid of the file_name and the feature_path
			path = File.dirname(file).gsub(@options[:feature_path_regexp], '')
			return {:path => path, :name => name}
		end

	end # class Main
end # module Cellophane

