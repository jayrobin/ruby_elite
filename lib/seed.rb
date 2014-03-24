class Seed
  attr_accessor :w0, :w1, :w2

	def initialize(w0, w1, w2)
		@w0 = w0
		@w1 = w1
		@w2 = w2
	end

	def tweak
		sum = @w0 + @w1 + @w2
		@w0, @w1, @w2 = @w1, @w2, sum
	end
end