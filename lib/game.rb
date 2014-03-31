require_relative 'seed'
require_relative 'galaxy'
require_relative 'player'

class Game
	attr_reader :running

	DEFAULT_SEED = Seed.new(0x5A4A, 0x0248, 0xB753)

	def initialize
		@galaxy = Galaxy.new(1)
		@galaxy.generate(DEFAULT_SEED)

		@player = Player.new(@galaxy.systems[7])
		@running = true
	end

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

	private

	def command_get_local
		local_planets = @galaxy.get_nearby_planets(@player.planet, @player.fuel)
		
		output = "Planets within #{@player.fuel} LY:\n"
		local_planets.each { |planet| output += "\t#{planet.print(true)}\t(#{planet.calculate_distance(@player.planet)} LY)\n" }
		output
	end

	def command_jump(planet_name)
		planet = @galaxy.get_planet(planet_name)
		return "Could not jump to #{planet_name}" if planet.nil?

		@player.jump_to(planet) ? planet.print(false) : "Not enough fuel"
	end

	def command_exit
		@running = false
		"Quitting game..."
	end

	def unknown_command(command)
		puts "Unrecognised command: #{command}"
	end
end