require_relative '../spec_helper'
require_relative '../../lib/planet'
require_relative '../../lib/seed'

describe Planet do
	subject { planet }
	let(:planet) { Planet.new(seed) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }

	it { should respond_to(:x, :y, :economy, :government, :tech_level, :population, :productivity, :radius, :name) }
end