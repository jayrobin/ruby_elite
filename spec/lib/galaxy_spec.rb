require_relative '../spec_helper'
require_relative '../../lib/galaxy'
require_relative '../../lib/seed'

describe Galaxy do
	subject { galaxy }
	let(:galaxy) { Galaxy.new(1) }
	let(:seed) { Seed.new(0x5A4A, 0x0248, 0xB753) }


	it { should be_an_instance_of(Galaxy) }
	it { should respond_to(:generate).with(1).argument }
	it { should respond_to(:systems) }

	it "should generate an array of planets" do
		expect { galaxy.generate(seed) }.to change { galaxy.systems.count }.to(256)
	end
end