require 'spec_helper'
require 'Galaxy'
require 'Seed'

describe Galaxy do
	subject { galaxy }
	let(:galaxy) { Galaxy.new(1, []) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }


	it { should be_an_instance_of(Galaxy) }
	it { should respond_to(:generate).with(1).argument }
	it { should respond_to(:systems) }
	it { should respond_to(:get_planet) }
	it { should respond_to(:get_nearby_planets).with(2).arguments }

	it "should generate an array of planets" do
		expect { galaxy.generate(seed) }.to change { galaxy.systems.count }.to(256)
	end

	context "#get_planet" do
		it "should return a planet object matching a given planet name" do
			planet_name = "some planet"
			planet = double()
			planet.stub(:name).and_return(planet_name)
			galaxy.stub(:systems).and_return([planet])

			galaxy.get_planet(planet_name).should == planet
		end

		it "should return nil given a non-existant planet name" do
			planet_name = "invalid planet"
			planet = double()
			planet.stub(:name).and_return(planet_name)

			galaxy.get_planet(planet_name).should be_nil
		end
	end

	context "#get_nearby_planets" do
		it "should return an array of planets within a given distance of a given planet" do
			galaxy.generate(seed)
			galaxy.get_nearby_planets(galaxy.systems[7], 100).count.should be > 0
		end
	end
end