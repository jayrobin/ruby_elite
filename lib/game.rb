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
		when "info"
			command_info(parts[1])
		when "jump"
			command_jump(parts[1])
		when "fuel"
			command_fuel(parts[1])
		when "exit"
			command_exit
		else
			unknown_command(parts[0])
		end
	end

	def get_player_cash
		@player.cash
	end

	private

	def command_get_local
		local_planets = @galaxy.get_nearby_planets(@player.planet, @player.fuel)
		
		output = "Galaxy number #{@galaxy.num}\n"
		output << format("Planets within %.1f LY:\n", @player.fuel)
		local_planets.each do |planet|
			output << (planet == @player.planet ? "* " : "- ")
			output << format("#{planet.print(true)}\t(%.1f LY)\n", planet.calculate_distance(@player.planet))
		end
		output
	end

	def command_info(planet_name)
		return "Must enter a planet name" if planet_name.nil?

		planet = @galaxy.get_planet(planet_name.upcase)
		planet.nil? ? "Could not find #{planet_name}" : planet.print(false)
	end

	def command_jump(planet_name)
		return "Must enter a planet name" if planet_name.nil?

		planet = @galaxy.get_planet(planet_name.upcase)
		return "Could not jump to #{planet_name}" if planet.nil?

		@player.jump_to(planet) ? planet.print(false) : "Not enough fuel"
	end

	def command_fuel(amount)
		return "Must supply an amount" if amount.nil?

		fuel = @player.buy_fuel(amount.to_f)
		format("You have %.1f LY of fuel", fuel)
	end

	def command_exit
		@running = false
		"Quitting game..."
	end

	def unknown_command(command)
		puts "Unrecognised command: #{command}"
	end
end