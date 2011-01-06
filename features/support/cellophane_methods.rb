module CellophaneMethods
	def call_cellophane(args = [])
		cellophane = Cellophane::Main.new(args)
		@command = cellophane.command
		@message = cellophane.message
	end

	def output_command
		puts "\n\n#{@command}\n\n"
	end

	def output_message
		puts "\n\n#{@message}\n\n"
	end
	
	def save_initial_dir
		@initial_dir = Dir.pwd
	end
	
	def restore_initial_dir
		Dir.chdir(@initial_dir)
	end
	
	def ensure_project_dir_removed
		FileUtils.remove_dir(@project_dir, true) if @project_dir && File.exist?(@project_dir)
	end
end

World(CellophaneMethods)