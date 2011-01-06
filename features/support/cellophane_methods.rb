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
end

World(CellophaneMethods)