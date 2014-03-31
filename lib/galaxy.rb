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

	def get_planet(planet_name)
		self.systems.each { |system| return system if system.name == planet_name }

		nil
	end

	def get_nearby_planets(planet, distance)
		self.systems.select { |system| planet.calculate_distance(system) <= distance } 
	end
end