require_relative '../spec_helper'
require_relative '../../lib/game'

describe Game do
	subject { game }
	let(:game) { Game.new }

	it { should be_an_instance_of(Game) }
	it { should respond_to(:run) }
end