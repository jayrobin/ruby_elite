class Player
	attr_accessor :galaxy, :planet, :cash, :fuel, :cargo_space, :cargo

	def initialize(galaxy, planet)
		@galaxy = galaxy
		@planet = planet

		@cash = 100
		@fuel = 10
		@cargo_space = 100
		@cargo = []
	end
end