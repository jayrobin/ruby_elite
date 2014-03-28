require 'spec_helper'
require 'Seed'

describe Seed do
	let(:seed) { Seed.new(1, 2, 3) }
	subject { seed }

	it { should be_an_instance_of(Seed) }
	its(:w0) { should == 1 }
	its(:w1) { should == 2 }
	its(:w2) { should == 3 }

	it { should respond_to(:w0, :w1, :w2) }

	context "#tweak" do
		it { should respond_to(:tweak) }

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

	context "#twist" do
		it { should respond_to(:twist) }

		it "should double w0 if w0 * 2 < 256" do
			temp = seed.w0
			expect { seed.twist }.to change { seed.w0 }.to(temp * 2)
		end

		it "should double w1 if w1 * 2 < 256" do
			temp = seed.w1
			expect { seed.twist }.to change { seed.w1 }.to(temp * 2)
		end

		it "should double w2 if w2 * 2 < 256" do
			temp = seed.w2
			expect { seed.twist }.to change { seed.w2 }.to(temp * 2)
		end

		it "should twist w0 if w0 * 2 >= 256" do
			temp = seed.w0 = 128
			expect { seed.twist }.to change { seed.w0 }.to(temp * 2 - 255)
		end

		it "should twist w1 if w1 * 2 >= 256" do
			temp = seed.w1 = 128
			expect { seed.twist }.to change { seed.w1 }.to(temp * 2 - 255)
		end

		it "should twist w2 if w2 * 2 >= 256" do
			temp = seed.w2 = 128
			expect { seed.twist }.to change { seed.w2 }.to(temp * 2 - 255)
		end
	end
end