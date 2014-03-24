require_relative 'fast_seed'

class Random
	def initialize(fast_seed)
		@fast_seed = fast_seed
	end

	def rnd
		x = (@fast_seed.a * 2) & 0xFF
		a = x + @fast_seed.c

		a += 1 if @fast_seed.a > 127

		@fast_seed.a = a & 0xFF
		@fast_seed.c = x

		a = a / 256
		x = @fast_seed.b
		a = (a + x + @fast_seed.d) & 0xFF

		@fast_seed.b = a
		@fast_seed.d = x

		a
	end

	def randbyte
		(rand * 65536).floor & 0xFF
	end
end