require_relative '../spec_helper'
require_relative '../../lib/player'
require_relative '../../lib/planet'
require_relative '../../lib/galaxy'
require_relative '../../lib/seed'

describe Player do
	subject { player }
	let(:player) { Player.new(galaxy, planet) }
	let(:galaxy) { Galaxy.new(1) }
	let(:planet) { Planet.new(seed) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }


	it { should be_an_instance_of(Player) }
	it { should respond_to(:galaxy, :planet, :cash, :fuel, :cargo, :cargo_space) }
	
	its(:galaxy) { should be_an_instance_of(Galaxy) }
	its(:planet) { should be_an_instance_of(Planet) }
	its(:cash) { should be >= 0 }
	its(:fuel) { should be >= 0 }
	its(:cargo) { should be_an_instance_of(Array) }
	its(:cargo_space) { should be_between(0, 1000) }
end