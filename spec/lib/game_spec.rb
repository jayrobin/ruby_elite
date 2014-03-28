require 'spec_helper'
require 'Game'

describe Game do
	subject { game }
	let(:game) { Game.new }

	it { should be_an_instance_of(Game) }
	it { should respond_to(:run) }
end