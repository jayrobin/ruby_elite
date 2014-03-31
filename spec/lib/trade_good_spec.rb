require 'spec_helper'
require 'trade_good'

describe TradeGood do
	subject { trade_good }
	let(:trade_good) { TradeGood.new(0, 0, 0, 0, "T", "ITEM") }

	it { should respond_to(:base_price, :gradient, :base_quant, :mask_byte, :unit, :name) }
end