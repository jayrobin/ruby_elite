require_relative '../spec_helper'
require_relative '../../lib/Seed'

describe "Seed" do
	let(:seed) { Seed.new(0, 1, 2) }
	subject { seed }

	it { should be_an_instance_of(Seed) }
	its(:w0) { should == 0 }
	its(:w1) { should == 1 }
	its(:w2) { should == 2 }

	it { should respond_to(:tweak) }

	context "#tweak" do
		it "should set w0 to w1" do
			expect { seed.tweak }.to change { seed.w0 }.to(seed.w1)
		end

		it "should set w1 to w2" do
			expect { seed.tweak }.to change { seed.w1 }.to(seed.w2)
		end

		it "should set w2 to (w0 + w1 + w2)" do
			expect { seed.tweak }.to change { seed.w2 }.to(seed.w0 + seed.w1 + seed.w2)
		end
	end
end