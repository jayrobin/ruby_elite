require_relative '../spec_helper'
require_relative '../../lib/Seed'

describe "Seed" do
	subject { Seed.new(0, 1, 2) }

	it { should be_an_instance_of(Seed) }
	its(:w0) { should == 0 }
	its(:w1) { should == 1 }
	its(:w2) { should == 2 }
end