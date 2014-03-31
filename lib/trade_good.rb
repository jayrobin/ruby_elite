class TradeGood
	attr_reader :base_price, :gradient, :base_quant, :mask_byte, :unit, :name

	def initialize(base_price, gradient, base_quant, mask_byte, unit, name)
		@base_price = base_price
		@gradient = gradient
		@base_quant = base_quant
		@mask_byte = mask_byte
		@unit = unit
		@name = name
	end
end