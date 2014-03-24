class FastSeed
	attr_accessor :a, :b, :c, :d
	
	def initialize(a, b, c, d)
		@a = a
		@b = b
		@c = c
		@d = d
	end

	def to_s
		"#{@a}, #{@b}, #{@c}, #{@d}"
	end
end