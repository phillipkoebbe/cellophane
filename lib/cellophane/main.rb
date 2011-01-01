require 'fileutils'
require 'cellophane/parser'
require 'cellophane/configuration'

module Cellophane
	class CellophaneException < Exception
	end
	
	class Main
		def initialize
			@options = Cellophane::Configuration.new.options
			
			raise CellophaneException.new('Improper regular expression provided.') if @options[:regexp] && @options[:pattern].nil?
			
			parser = Cellophane::Parser.new(@options)
			@features = parser.features
			
			raise CellophaneException.new('No features matching pattern were found.') unless @features
			
			@tags = parser.tags
		end

		def run
			feature_files = []
			step_files = []
			@features.each do |file|
				file_parts = split_feature(file)
				feature_files << construct_feature_file(file_parts[:path], file_parts[:name])
				step_files << construct_step_file(file_parts[:path], file_parts[:name])
			end

			cuke_cmd = "cucumber #{@options[:cucumber]}"

			requires = (@options[:requires] + step_files).compact.uniq
			cuke_cmd += " -r #{requires.join(' -r ')}" if requires.any?
			
			execute "#{cuke_cmd} #{feature_files.join(' ')} #{@tags}".gsub('  ', ' ')
		end
		
		private
		
		def construct_feature_file(path, file)
			"#{@options[:feature_path]}/#{path}/#{file}.feature".gsub('//', '/')
		end
		
		def construct_step_file(path, file)
			step_path = @options[:step_path].is_a?(Hash) ? "#{options[:feature_path]}/#{path}/#{@options[:step_path][:nested_in]}" : "#{@options[:step_path]}/#{path}"
			step_file = "#{step_path}/#{file}_steps.rb".gsub('//', '/')
			return File.exist?(step_file) ? step_file : nil
		end
		
		def execute(cmd)
			@options[:dry_run] ? puts(cmd) : system("#{cmd}\n\n")
		end

		def split_feature(file)
			name = File.basename(file, '.feature')
			# now get rid of the file_name and the feature_path
			path = File.dirname(file).gsub(@options[:feature_path_regexp], '')
			return {:path => path, :name => name}
		end

	end # class Main
end # module Cellophane

