require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cellophane"
  gem.homepage = "http://github.com/phillipkoebbe/cellophane"
  gem.license = "MIT"
  gem.summary = "A thin wrapper around Cucumber."
  gem.description = "Cellophane is a thin wrapper around Cucumber, making it easier to be creative when running features."
  gem.email = "phillip@livingdoor.net"
  gem.authors = ["Phillip Koebbe"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cellophane #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
