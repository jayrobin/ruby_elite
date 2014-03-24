require_relative '../spec_helper'

describe Random do
	subject { Random.new(seed) }
	let(:seed) { Seed.new(0, 1, 2) }

	it { should be_an_instance_of(Random) }
end