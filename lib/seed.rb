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

	def twist
		@w0 = twist_int(@w0)
		@w1 = twist_int(@w1)
		@w2 = twist_int(@w2)
	end

	def to_s
		"#{@w0}, #{@w1}, #{@w2}"
	end

	private

	def twist_int(num)
		num *= 2
		num > 255 ? num - 255 : num
	end
end