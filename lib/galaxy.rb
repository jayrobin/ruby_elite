require_relative 'planet'

class Galaxy
	attr_reader :systems

	NUM_SYSTEMS = 256

	def initialize(num)
		@num = num
		@systems = []
	end

	def generate(seed)
		@num.times { seed.twist }

		@systems = []
		NUM_SYSTEMS.times do
			@systems << Planet.new(seed)
		end
	end
end