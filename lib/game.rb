require_relative 'seed'
require_relative 'galaxy'
require_relative 'player'

class Game
	DEFAULT_SEED = Seed.new(0x5A4A, 0x0248, 0xB753)

	def initialize
		@galaxy = Galaxy.new(1)
		@galaxy.generate(DEFAULT_SEED)

		@player = Player.new(@galaxy.systems[0])
	end

	def run
		running = true
		while(running) do
			input = gets.chomp
			puts input

			running = false if input == "exit"
		end
	end
end

game = Game.new
game.run