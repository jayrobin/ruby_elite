require 'spec_helper'
require 'Player'
require 'Planet'
require 'Galaxy'
require 'Seed'

describe Player do
	subject { player }
	let(:player) { Player.new(planet) }
	let(:planet) { Planet.new(seed) }
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
		let(:other_planet) { Planet.new(seed) }

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
end