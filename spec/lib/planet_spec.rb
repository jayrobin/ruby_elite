require 'spec_helper'
require 'Planet'
require 'Seed'

describe Planet do
	subject { planet }
	let(:planet) { Planet.new(seed) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }

	it { should be_an_instance_of(Planet) }
	it { should respond_to(:x, :y, :economy, :government, :tech_level, :population, :productivity, :radius, :name) }
	it { should respond_to(:calculate_distance).with(1).argument }
	it { should respond_to(:print).with(1).argument }

	its(:x) { should be_between(0, 255) }
	its(:y) { should be_between(0, 255) }
	its(:economy) { should be_between(0, 7) }
	its(:government) { should be_between(0, 7) }
	its(:tech_level) { should be_between(0, 7) }
	its(:population) { should be_between(0, 43) }
	its(:name) { should be_an_instance_of(String) }

	context "#calculate_distance" do
		it "should calculate the distance between two planets" do
			other_planet = double()
			other_planet.stub(:x).and_return(0)
			other_planet.stub(:y).and_return(0)

			planet.calculate_distance(other_planet).should > 0
		end

		it "should return 0 for planets in the same position" do
			planet.calculate_distance(planet).should == 0
	  end
	end
end