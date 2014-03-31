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
	it { should respond_to(:buy_fuel).with(1).argument }
	
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
end