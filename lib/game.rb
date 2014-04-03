require_relative 'seed'
require_relative 'galaxy'
require_relative 'player'
require_relative 'trade_good'

class Game
	attr_reader :running

	def initialize
		commodities = load_commodities(false)

		@galaxy = Galaxy.new(1, commodities)
		@galaxy.generate(Seed.new(0x5A4A, 0x0248, 0xB753))

		@player = Player.new(@galaxy.systems[7], commodities.size)
		@running = true
	end

	def parse(input)
		parts = input.split(" ")

		case parts[0]
		when "buy", "b"
			command_buy(parts[1], parts[2])
		when "sell", "s"
			command_sell(parts[1], parts[2])
		when "local", "l"
			command_get_local
		when "info", "i"
			command_info(parts[1])
		when "mkt", "m"
			command_mkt
		when "jump", "j"
			command_jump(parts[1])
		when "sneak", "s"
			command_jump(parts[1], true)
		when "galhyp", "g"
			command_galhyp
		when "fuel", "f"
			command_fuel(parts[1])
		when "cash", "c"
			command_cash(parts[1])
		when "hold", "h"
			command_hold(parts[1])
		when "help"
			command_help
		when "exit", "e"
			command_exit
		else
			unknown_command(parts[0])
		end
	end

	def get_player_cash
		@player.cash
	end

	private

	def command_buy(item_name, amount = 0)
		amount = @player.buy(item_name, amount.to_i)
		return "Could not complete trade\n" if amount == 0

		"Purchased #{amount} of #{item_name}\n"
	end

	def command_sell(item_name, amount = 0)
		amount = @player.sell(item_name, amount.to_i)
		return "Could not complete trade\n" if amount == 0

		"Sold #{amount} of #{item_name}\n"
	end

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
		planet_name ||= @player.planet.name

		planet = @galaxy.get_planet(planet_name.upcase)
		planet.nil? ? "Could not find #{planet_name}" : planet.print(false)
	end

	def command_mkt
		@player.get_market << "Fuel: #{@player.fuel}\tCargo Space: #{@player.cargo_space}\n"
	end

	def command_jump(planet_name, sneak = false)
		return "Must enter a planet name\n" if planet_name.nil?

		planet = @galaxy.get_planet(planet_name.upcase)
		return "Could not jump to #{planet_name}\n" if planet.nil? || planet == @player.planet

		@player.jump_to(planet, sneak) ? planet.print(false) : "Not enough fuel\n"
	end

	def command_galhyp
		current_planet_index = @galaxy.get_planet_index(@player.planet)
		@galaxy.next(Seed.new(0x5A4A, 0x0248, 0xB753))
		@player.jump_to(@galaxy.systems[current_planet_index], true)

		"Galaxy jump complete, now on #{@player.planet.name}\n"
	end

	def command_fuel(amount)
		return "Must supply an amount\n" if amount.nil?

		fuel = @player.buy_fuel(amount.to_f)
		format("You have %.1f LY of fuel\n", fuel)
	end

	def command_cash(amount)
		return "Must supply an amount" if amount.nil?

		"Cash set to $#{@player.cash = amount.to_f.abs}\n"
	end

	def command_hold(amount)
		return "Must supply an amount" if amount.nil?

		"Hold set to #{@player.cargo_space = amount.to_f.abs}\n"
	end

	def command_help
    output = "\nCommands are:"
    output << "\nBuy   tradegood amount"
    output << "\nSell  tradegood amount"
    output << "\nFuel  amount    (buy amount LY of fuel)"
    output << "\nJump  planetname (limited by fuel)"
    output << "\nSneak planetname (any distance - no fuel cost)"
    output << "\nGalhyp           (jumps to next galaxy)"
    output << "\nInfo  planetname (prints info on system"
    output << "\nMkt              (shows market prices)"
    output << "\nLocal            (lists systems within 7 light years)"
    output << "\nCash number      (alters cash - cheating!)"
    output << "\nHold number      (change cargo bay)"
    output << "\nQuit or ^C       (exit)"
    output << "\nHelp             (display this text)"
    #output << "\nRand             (toggle RNG)"
    output << "\n\nAbbreviations allowed eg. b fo 5 = Buy Food 5, m= Mkt\n"
	end

	def command_exit
		@running = false
		"Quitting game...\n"
	end

	def unknown_command(command)
		"Unrecognised command: #{command}\n"
	end

	def load_commodities(politically_correct)
		unit_t = "t"
		unit_kg = "kg"
		unit_g = "g"

		@commodities = []
		@commodities << TradeGood.new(0x13, -0x02, 0x06, 0x01, unit_t, "Food        ")
    @commodities << TradeGood.new(0x14, -0x01, 0x0A, 0x03, unit_t, "Textiles    ")
    @commodities << TradeGood.new(0x41, -0x03, 0x02, 0x07, unit_t, "Radioactives")
    @commodities << TradeGood.new(0x28, -0x05, 0xE2, 0x1F, unit_t, politically_correct ? "Robot_Slaves" : "Slaves      ")
    @commodities << TradeGood.new(0x53, -0x05, 0xFB, 0x0F, unit_t, politically_correct ? "Beverages   " : "Liquor/Wines")
    @commodities << TradeGood.new(0xC4, +0x08, 0x36, 0x03, unit_t, "Luxuries    ")
    @commodities << TradeGood.new(0xEB, +0x1D, 0x08, 0x78, unit_t, politically_correct ? "Rare_Species" : "Narcotics   ")
    @commodities << TradeGood.new(0x9A, +0x0E, 0x38, 0x03, unit_t, "Computers   ")
    @commodities << TradeGood.new(0x75, +0x06, 0x28, 0x07, unit_t, "Machinery   ")
    @commodities << TradeGood.new(0x4E, +0x01, 0x11, 0x1F, unit_t, "Alloys      ")
    @commodities << TradeGood.new(0x7C, +0x0d, 0x1D, 0x07, unit_t, "Firearms    ")
    @commodities << TradeGood.new(0xB0, -0x09, 0xDC, 0x3F, unit_t, "Furs        ")
    @commodities << TradeGood.new(0x20, -0x01, 0x35, 0x03, unit_t, "Minerals    ")
    @commodities << TradeGood.new(0x61, -0x01, 0x42, 0x07, unit_kg, "Gold        ")
    @commodities << TradeGood.new(0xAB, -0x02, 0x37, 0x1F, unit_kg, "Platinum    ")
    @commodities << TradeGood.new(0x2D, -0x01, 0xFA, 0x0F, unit_g, "Gem_Stones ")
    @commodities << TradeGood.new(0x35, +0x0F, 0xC0, 0x07, unit_t, "Alien_Items ")
	end
end