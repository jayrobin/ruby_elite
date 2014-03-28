require_relative 'seed'
require_relative 'galaxy'
require_relative 'player'

class Game
	DEFAULT_SEED = Seed.new(0x5A4A, 0x0248, 0xB753)

	def initialize
		@galaxy = Galaxy.new(1)
		@galaxy.generate(DEFAULT_SEED)

		@player = Player.new(@galaxy.systems[7])
	end

	def run
		@running = true
		while(@running) do
			input = gets.chomp
			puts parse(input)
		end
	end

	private

	def parse(input)
		parts = input.split(" ")

		case parts[0]
		when "local"
			command_get_local
		when "jump"
			command_jump(parts[1].upcase)
		when "exit"
			command_exit
		else
			unknown_command(parts[0])
		end
	end

	def command_get_local
		local_planets = @galaxy.get_nearby_planets(@player.planet, @player.fuel)
		
		output = "Planets within #{@player.fuel} LY:\n"
		local_planets.each { |planet| output += " #{planet.name} (#{planet.calculate_distance(@player.planet)} LY)\n" }
		output
	end

	def command_jump(planet_name)
		planet = @galaxy.get_planet(planet_name)
		return "Could not find #{planet_name}" if planet.nil?

		@player.jump_to(planet)
	end

	def command_exit
		@running = false
	end

	def unknown_command(command)
		puts "Unrecognised command: #{command}"
	end
end

game = Game.new
game.run