require_relative 'seed'
require_relative 'galaxy'
require_relative 'player'
require_relative 'trade_good'

class Game
	attr_reader :running

	DEFAULT_SEED = Seed.new(0x5A4A, 0x0248, 0xB753)
	POLITICALLY_CORRECT = false
	UNIT_T = "t"
	UNIT_KG = "kg"
	UNIT_G = "g"

	def initialize
		@galaxy = Galaxy.new(1, load_commodities)
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
		when "mkt"
			command_mkt
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

	def command_mkt
		@player.planet.get_market
	end

	def command_jump(planet_name)
		return "Must enter a planet name" if planet_name.nil?

		planet = @galaxy.get_planet(planet_name.upcase)
		return "Could not jump to #{planet_name}" if planet.nil? || planet == @player.planet

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

	def load_commodities
		@commodities = []
		@commodities << TradeGood.new(0x13, -0x02, 0x06, 0x01, UNIT_T, "Food        ")
    @commodities << TradeGood.new(0x14, -0x01, 0x0A, 0x03, UNIT_T, "Textiles    ")
    @commodities << TradeGood.new(0x41, -0x03, 0x02, 0x07, UNIT_T, "Radioactives")
    @commodities << TradeGood.new(0x28, -0x05, 0xE2, 0x1F, UNIT_T, POLITICALLY_CORRECT ? "Robot Slaves" : "Slaves      ")
    @commodities << TradeGood.new(0x53, -0x05, 0xFB, 0x0F, UNIT_T, POLITICALLY_CORRECT ? "Beverages   " : "Liquor/Wines")
    @commodities << TradeGood.new(0xC4, +0x08, 0x36, 0x03, UNIT_T, "Luxuries    ")
    @commodities << TradeGood.new(0xEB, +0x1D, 0x08, 0x78, UNIT_T, POLITICALLY_CORRECT ? "Rare Species" : "Narcotics   ")
    @commodities << TradeGood.new(0x9A, +0x0E, 0x38, 0x03, UNIT_T, "Computers   ")
    @commodities << TradeGood.new(0x75, +0x06, 0x28, 0x07, UNIT_T, "Machinery   ")
    @commodities << TradeGood.new(0x4E, +0x01, 0x11, 0x1F, UNIT_T, "Alloys      ")
    @commodities << TradeGood.new(0x7C, +0x0d, 0x1D, 0x07, UNIT_T, "Firearms    ")
    @commodities << TradeGood.new(0xB0, -0x09, 0xDC, 0x3F, UNIT_T, "Furs        ")
    @commodities << TradeGood.new(0x20, -0x01, 0x35, 0x03, UNIT_T, "Minerals    ")
    @commodities << TradeGood.new(0x61, -0x01, 0x42, 0x07, UNIT_KG, "Gold        ")
    @commodities << TradeGood.new(0xAB, -0x02, 0x37, 0x1F, UNIT_KG, "Platinum    ")
    @commodities << TradeGood.new(0x2D, -0x01, 0xFA, 0x0F, UNIT_G, "Gem-Stones ")
    @commodities << TradeGood.new(0x35, +0x0F, 0xC0, 0x07, UNIT_T, "Alien Items ")
	end
end