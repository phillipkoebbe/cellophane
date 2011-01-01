module Cellophane
	class Parser
		def initialize(options)
			@options = options
		end
		
		def features
			# if no pattern is specified, let cucumber run 'em all
			return [] if @options[:pattern].nil?
			collected_features = @options[:regexp] ? collect_features_by_regexp : collect_features_by_glob
			return collected_features.any? ? collected_features : nil
		end # features

		def tags
			only = []
			except = []
			tag_pattern = @options[:tags]

			tags = ''

			unless tag_pattern.nil?
				# going to either run certain ones or exclude certain ones
				tag_pattern.split(',').each do |t|
					# if tags are numeric, let's support ranges !!!
					if t =~ /^(~)?([0-9]+)-([0-9]+)$/
						x = $2.to_i
						y = $3.to_i
						exclude = $1
						
						# in case the user put them in the wrong order ... doh!
						if x > y
							z = x.dup
							x = y.dup
							y = z.dup
						end
						
						(x..y).each do |i|
							if exclude
								except << "~@#{i}"
							else
								only << "@#{i}"
							end
						end
					else
						if t[0].chr == '~'
							except << "~@#{t[1..t.length]}"
						else
							only << "@#{t}"
						end
					end
				end

				only.uniq!
				except.uniq!
				
				tags += "-t #{only.join(',')} " if only.any?
				tags += "-t #{except.join(' -t ')}" if except.any?
			end
	
			# if the user passes in tags with @ already in it
			tags.gsub('@@', '@')
		end # def self.parse_tags
		
		private

		def collect_features_by_regexp
			features = []

			# start by globbing all feature files
			Dir.glob("#{@options[:feature_path]}/**/*.feature").each do |feature_file|
				# keep the ones that match the regexp
				features << feature_file if @options[:pattern].match(feature_file)
			end
			
			features.uniq
		end # collect_features_by_regexp
		
		def collect_features_by_glob
			only = []
			except = []
			features_to_include = []
			features_to_exclude = []
			pattern = @options[:pattern].dup

			# want to run certain ones and/or exclude certain ones
			pattern.split(',').each do |f|
				if f[0].chr == '~'
					except << f[1..f.length]
				else
					only << f
				end
			end

			# if we have an exception, we want to get all features by default
			pattern = '**/*' if except.any?
			# unless we specifically say we want only certain ones
			pattern = nil if only.any?

			if only.any?
				only.each do |f|
					features_to_include += Dir.glob("#{@options[:feature_path]}/#{f}.feature")
				end
			else
				features_to_include += Dir.glob("#{@options[:feature_path]}/#{pattern}.feature")
			end

			if except.any?
				except.each do |f|
					features_to_exclude = Dir.glob("#{@options[:feature_path]}/#{f}.feature")
				end
			end
	
			(features_to_include - features_to_exclude).uniq
		end # collect_features_by_glob
	end # class Parser
end # module Cellophane