require_relative 'game'

class Elite
	def initialize
		@game = Game.new
	end

	def run
		while(@game.running) do
			print format("$%.1f > ", @game.get_player_cash)
			input = gets.chomp
			puts @game.parse(input) << "\n"
		end
	end
end

elite = Elite.new
elite.run