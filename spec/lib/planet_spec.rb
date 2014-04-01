require 'spec_helper'
require 'Planet'
require 'Seed'
require 'trade_good'

describe Planet do
	subject { planet }
	let(:planet) { Planet.new(seed, []) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }

	it { should be_an_instance_of(Planet) }
	it { should respond_to(	:x, :y, :economy, :government, :tech_level, :population, :productivity, 
													:radius, :name, :market_quantities, :market_prices) }
	it { should respond_to(:calculate_distance).with(1).argument }
	it { should respond_to(:print).with(1).argument }
	it { should respond_to(:set_market).with(2).arguments }
	it { should respond_to(:get_item_quantity).with(1).arguments }
	it { should respond_to(:get_item_index).with(1).arguments }
	it { should respond_to(:take_item).with(2).arguments }
	it { should respond_to(:give_item).with(2).arguments }


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

	before(:each) do
		planet.set_market(0, [TradeGood.new(1, 0, 0, 0, "T", "some item")])
	end

	context "#get_item_index" do
		it "should return the item index given a valid item name" do
			planet.get_item_index("some item").should == 0
		end

		it "should return nil given an invalid name" do
			planet.get_item_index("invalid item").should be_nil
		end
	end

	context "#get_item_quantity" do
		it "should return the quantity of an item given a valid index" do
			planet.market_quantities[0] = 10
			planet.get_item_quantity(0).should == 10
		end

		it "should return 0 of an item given an invalid index" do
			planet.get_item_quantity(-1).should == 0
		end
	end

	context "#take_item" do
		before(:each) do
			planet.market_quantities[0] = 10
		end

		it "should reduce the item quantity by the amount" do
			expect { planet.take_item(0, 5) }.to change { planet.market_quantities[0] }.by(-5)
		end

		it "should not reduce the item quantity to below 0" do
			expect { planet.take_item(0, 100) }.to change { planet.market_quantities[0] }.by(-10)
		end

		it "should return the amount taken" do
			planet.take_item(0, 5).should == 5
		end

		it "should return the original item quantity if the amount given was greater" do
			planet.take_item(0, 100).should == 10
		end
	end

	context "#give_item" do
		it "should increase the item quantity by the amount" do
			expect { planet.give_item(0, 5) }.to change { planet.market_quantities[0] }.by(5)
		end
	end
end