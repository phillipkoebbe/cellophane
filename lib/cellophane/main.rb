require 'fileutils'
require 'cellophane/parser'
require 'cellophane/options'

module Cellophane
	
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
			@options[:print] ? puts(@command) : system("#{@command}\n\n")
		end
		
		private
		
		def generate_command
			cuke_cmd = "#{@options[:cuke_command]} #{@options[:cucumber]}"

			features = []
			steps = []

			if @features.any?
				@features.each do |file|
					file_parts = split_feature(file)
					features << construct_feature_file(file_parts[:path], file_parts[:name])
					steps << construct_step_file(file_parts[:path], file_parts[:name])
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
		
		def construct_step_file(path, file)
			step_path = @options[:step_path].is_a?(Hash) ? "#{@options[:feature_path]}/#{path}/#{@options[:step_path][:nested_in]}" : "#{@options[:step_path]}/#{path}"
			step_file = "#{step_path}/#{file}_steps.rb".gsub('//', '/')
			return File.exist?(step_file) ? step_file : nil
		end
		
		def split_feature(file)
			name = File.basename(file, '.feature')
			# now get rid of the file_name and the feature_path
			path = File.dirname(file).gsub(@options[:feature_path_regexp], '')
			return {:path => path, :name => name}
		end

	end # class Main
end # module Cellophane

