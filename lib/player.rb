class Player
	attr_accessor :planet, :cash, :fuel, :cargo_space, :cargo

	def initialize(planet)
		@planet = planet

		@cash = 100
		@fuel = 10
		@cargo_space = 100
		@cargo = []
	end

	def jump_to(other_planet)
		distance = @planet.calculate_distance(other_planet)
		
		if distance <= @fuel
			@planet = other_planet
			@fuel -= distance
		end
	end
end