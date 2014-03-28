require 'spec_helper'
require_relative '../../lib/fast_seed'

describe "FastSeed" do
	let(:fast_seed) { FastSeed.new(1, 2, 3, 4) }
	subject { fast_seed }

	it { should be_an_instance_of(FastSeed) }
	it { should respond_to(:a, :b, :c, :d) }

	its(:a) { should == 1 }
	its(:b) { should == 2 }
	its(:c) { should == 3 }
	its(:d) { should == 4 }
end