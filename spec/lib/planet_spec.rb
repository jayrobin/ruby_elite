require_relative '../spec_helper'
require_relative '../../lib/planet'
require_relative '../../lib/seed'

describe Planet do
	subject { planet }
	let(:planet) { Planet.new(seed) }
	let(:seed) { Seed.new((0xFFFF * rand).floor, 0x0248, 0xB753) }

	it { should be_an_instance_of(Planet) }
	it { should respond_to(:x, :y, :economy, :government, :tech_level, :population, :productivity, :radius, :name) }
	
	its(:x) { should be_between(0, 255) }
	its(:y) { should be_between(0, 255) }
	its(:economy) { should be_between(0, 7) }
	its(:government) { should be_between(0, 7) }
	its(:tech_level) { should be_between(0, 7) }
	its(:population) { should be_between(0, 43) }
	its(:name) { should be_an_instance_of(String) }
end