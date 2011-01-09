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
			tags = {
				:or => [],
				:and => [],
				:not => []
			}

			return '' if @options[:tags].nil?

			@options[:tags].split(',').each do |t|
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
							tags[:not] << "#{i}"
						else
							tags[:or] << "#{i}"
						end
					end
				else
					if t =~ /^~(.+)/
						tags[:not] << $1
					elsif t =~ /^\+(.+)/
						tags[:and] << $1
					else
						tags[:or] << t
					end
				end
			end # each

			[:and, :or, :not].each { |type| tags[type].uniq! }
			
			# if there are AND/OR tags, remove any NOT tags so we avoid
			# duplicating the tag when passing to cucumber...so instead of
			# cucumber -t @1,@2,@3 -t ~@2
			# we'd like to see
			# cucumber -t @1,@3

			intersection = tags[:or] & tags[:not]
			tags[:or] -= intersection
			tags[:not] -= intersection

			intersection = tags[:and] & tags[:not]
			tags[:and] -= intersection
			tags[:not] -= intersection

			# now add @ and ~ as appropriate
			tags[:or].each_with_index { |tag, i| tags[:or][i] = "@#{tag}" }
			tags[:and].each_with_index { |tag, i| tags[:and][i] = "@#{tag}" }
			tags[:not].each_with_index { |tag, i| tags[:not][i] = "~@#{tag}" }

			tags_fragment = ''
			tags_fragment += "-t #{tags[:or].join(',')} " if tags[:or].any?
			tags_fragment += "-t #{tags[:and].join(' -t ')} " if tags[:and].any?
			tags_fragment += "-t #{tags[:not].join(' -t ')}" if tags[:not].any?
	
			# if the user passes in tags with @ already in it
			tags_fragment.gsub('@@', '@')
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