require_relative 'game'

class Elite
	def initialize
		@game = Game.new
	end

	def run
		while(@game.running) do
			input = gets.chomp
			puts @game.parse(input)
		end
	end
end

elite = Elite.new
elite.run