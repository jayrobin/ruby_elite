require 'spec_helper'
require 'Random'
require_relative '../../lib/fast_seed'

describe Random do
	subject { random }
	let(:random) { Random.new(fast_seed) }
	let(:random_copy) { Random.new(FastSeed.new(1, 2, 3, 4)) }
	let(:fast_seed) { FastSeed.new(1, 2, 3, 4) }

	it { should be_an_instance_of(Random) }
	it { should respond_to(:rnd) }
	it { should respond_to(:randbyte) }

	context "#rnd" do
		it "should return a predictable sequence of randoms with the same input" do
			sequence_a = []
			sequence_b = []
			20.times do
				sequence_a << random.rnd
				sequence_b << random_copy.rnd
			end
			
			sequence_a.should == sequence_b
		end
	end

	context "#randbyte" do
		it "should return a number between 0 and 255" do
			sequence = []
			100.times do
				sequence << random.randbyte
			end

			sequence.min >= 0 && sequence.max <= 255
		end
	end
end