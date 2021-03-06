require_relative 'random'
require_relative 'Game'

class Player
	attr_accessor :planet, :cash, :fuel, :cargo_space, :cargo

	MAX_FUEL = 7

	def initialize(planet, num_commodities)
		@planet = planet

		@cash = 100
		@fuel = MAX_FUEL
		@cargo_space = 100
		@cargo = Array.new(num_commodities, 0)
	end

	def get_market
		output = ""
		market = @planet.get_market

		market.each_with_index do |mkt, index|
			output << "#{mkt}"
			output << (@cargo[index] > 0 ? "\t#{@cargo[index]}\n" : "\n")
		end

		output
	end

	def jump_to(other_planet, sneak = false)
		distance = sneak ? 0 : @planet.calculate_distance(other_planet)

		if distance <= @fuel
			set_planet(other_planet)
			@fuel -= distance
			return true
		end

		false	# could not jump: not enough fuel
	end

	def buy_fuel(amount)
		amount = [[amount, @cash, MAX_FUEL - @fuel].min, 0].max

		@cash -= amount
		@fuel += amount
	end

	def get_used_cargo_space
		@cargo.inject(0, :+)
	end

	def buy(item_name, amount)
		item_index = @planet.get_item_index(item_name)
		return 0 if item_index.nil?

		price = @planet.get_item_price(item_index)
		item_unit = @planet.get_item_unit(item_index)

		amount = [amount, @planet.get_item_quantity(item_index), (@cash.to_f / price).floor].min
		amount = [amount, cargo_space].min if item_unit == "T"

		@cash -= amount * price
		@cargo[item_index] += amount
		@cargo_space -= amount if item_unit == "T"
		@planet.take_item(item_index, amount)
	end

	def sell(item_name, amount)
		item_index = @planet.get_item_index(item_name)
		return 0 if item_index.nil?

		price = @planet.get_item_price(item_index)
		item_unit = @planet.get_item_unit(item_index)

		amount = [amount, cargo[item_index]].min

		@cash += amount * price
		@cargo[item_index] -= amount
		@cargo_space += amount if item_unit == "T"
		@planet.give_item(item_index, amount)

		amount
	end

	private

	def set_planet(other_planet)
		@planet = other_planet
		other_planet.set_market((rand * 65536).floor & 0xFF)
	end
end