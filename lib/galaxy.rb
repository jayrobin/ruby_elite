require_relative 'planet'

class Galaxy
	attr_reader :num, :systems

	NUM_SYSTEMS = 256

	def initialize(num, commodities)
		@num = num
		@commodities = commodities
		@systems = []
	end

	def generate(seed)
		@seed = seed
		@num.times { @seed.twist }

		@systems = []
		NUM_SYSTEMS.times do
			@systems << Planet.new(@seed, @commodities)
		end
	end

	def next
		@num += 1
		@num = 1 if @num > 9

		generate(@seed)
	end

	def get_planet(planet_name)
		self.systems.each { |system| return system if system.name == planet_name }

		nil
	end

	def get_planet_index(planet)
		self.systems.each_with_index { |system, index| return index if system == planet }

		nil
	end

	def get_nearby_planets(planet, distance)
		self.systems.select { |system| planet.calculate_distance(system) <= distance } 
	end
end