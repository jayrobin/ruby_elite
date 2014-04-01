require 'spec_helper'
require 'Player'
require 'Planet'
require 'Galaxy'
require 'Seed'

describe Player do
	subject { player }
	let(:player) { Player.new(planet) }
	let(:planet) { Planet.new(seed, []) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }


	it { should be_an_instance_of(Player) }
	it { should respond_to(:planet, :cash, :fuel, :cargo, :cargo_space) }
	
	its(:planet) { should be_an_instance_of(Planet) }
	its(:cash) { should be >= 0 }
	its(:fuel) { should be >= 0 }
	its(:cargo) { should be_an_instance_of(Array) }
	its(:cargo_space) { should be_between(0, 1000) }


	it { should respond_to(:jump_to).with(1).argument }
	context "#jump_to" do
		let(:other_planet) { Planet.new(seed, []) }

		it "should change player planet when jumping" do
			planet.stub(:calculate_distance).and_return(0)
			expect { player.jump_to(other_planet) }.to change { player.planet }.from(planet).to(other_planet)
		end

		it "should reduce the fuel amount by the distance when jumping" do
			planet.stub(:calculate_distance).and_return(1)
			expect { player.jump_to(other_planet) }.to change { player.fuel }.by(-1)
		end

		it "should prevent jumping to out-of-range planets" do
			planet.stub(:calculate_distance).and_return(100)
			expect { player.jump_to(other_planet) }.to change { player.fuel }.by(0)
		end
	end

	it { should respond_to(:buy_fuel).with(1).argument }
	context "#buy_fuel" do
		it "should increase fuel by the amount supplied" do
			expect { player.buy_fuel(1) }.to change { player.fuel }.by(1)
		end

		it "should decrease cash by the amount supplied" do
			expect { player.buy_fuel(1) }.to change { player.cash }.by(-1)
		end

		it "should not buy any fuel if a negative number is supplied" do
			expect { player.buy_fuel(-1) }.to change { player.fuel }.by(0)
		end

		it "should not spend any cash if a negative number is supplied" do
			expect { player.buy_fuel(-1) }.to change { player.cash }.by(0)
		end

		it "should limit the fuel purchase to the player's current cash" do
			max_fuel = player.cash
			expect { player.buy_fuel(max_fuel * 2) }.to change { player.fuel }.by(max_fuel)
		end
	end

	it { should respond_to(:get_used_cargo_space) }
	context "#get_used_cargo_space" do
		it "should return 0 if the cargo is empty" do
			player.cargo = []
			player.get_used_cargo_space.should == 0
		end

		it "should return player.cargo_space if the cargo is full" do
			total_space = player.cargo_space
			player.cargo = [player.cargo_space / 2, player.cargo_space / 2]
			player.get_used_cargo_space.should == total_space
		end
	end

	it { should respond_to(:buy).with(2).arguments }
	context "#buy" do
		before(:each) do
			planet.set_market(0, [TradeGood.new(1, 0, 0, 0, "T", "some item")])
			planet.market_quantities[0] = 10
			planet.market_prices[0] = 1
		end

		it "should reduce player cash by amount * item price" do
			expect { player.buy("some item", 5) }.to change { player.cash }.by(-5 * planet.get_item_price(0))
		end

		it "should reduce free player cargo by amount" do
			expect { player.buy("some item", 5) }.to change { player.cargo_space }.by(-5)
		end

		it "should reduce planet stock of item by amount" do
			expect { player.buy("some item", 5) }.to change { planet.market_quantities[0] }.by(-5)
		end

		it "should increase player stock of item by amount" do
			expect { player.buy("some item", 5) }.to change { player.cargo[0] }.by(5)
		end

		it "should return amount" do
			player.buy("some item", 5).should == 5
		end

		it "should limit the purchase to the maximum the player can afford" do
			player.cash = 1
			expect { player.buy("some item", 999) }.to change { player.cash }.to(0)
		end

		it "should limit the purchase to the maximum the player can store" do
			planet.market_quantities[0] = 999
			expect { player.buy("some item", 999) }.to change { player.cargo_space }.to(0)
		end

		it "should limit the purchase to the stock held by the planet" do
			expect { player.buy("some item", 999) }.to change { planet.market_quantities[0] }.to(0)
		end
	end

	it { should respond_to(:sell).with(2).arguments }
	context "#sell" do
		before(:each) do
			planet.set_market(0, [TradeGood.new(1, 0, 0, 0, "T", "some item")])
			planet.market_prices[0] = 1
			player.cargo[0] = 10
		end

		it "should increase player cash by amount * item price" do
			expect { player.sell("some item", 5) }.to change { player.cash }.by(5 * planet.get_item_price(0))
		end

		it "should increase free player cargo by amount" do
			expect { player.sell("some item", 5) }.to change { player.cargo_space }.by(5)
		end

		it "should increase planet stock of item by amount" do
			expect { player.sell("some item", 5) }.to change { planet.market_quantities[0] }.by(5)
		end

		it "should reduce player stock of item by amount" do
			expect { player.sell("some item", 5) }.to change { player.cargo[0] }.by(-5)
		end

		it "should return amount" do
			player.sell("some item", 5).should == 5
		end

		it "should limit the sale to the quantity held by the player" do
			planet.market_quantities[0] = 0
			player.cargo[0] = 10
			expect { player.sell("some item", 999) }.to change { planet.market_quantities[0] }.by(10)
		end
	end
end