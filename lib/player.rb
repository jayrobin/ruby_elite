require_relative 'random'

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
			other_planet.set_market((rand * 65536).floor & 0xFF)
			@fuel -= distance
			return true
		end

		false	# could not jump: not enough fuel
	end

	def buy_fuel(amount)
		amount = [[amount, @cash].min, 0].max

		@cash -= amount
		@fuel += amount
	end
end