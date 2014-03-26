class Planet
	attr_reader :x, :y, :economy, :government, :tech_level, :population, :productivity, :radius, :name

	LETTER_PAIRS = "..LEXEGEZACEBISO" +
                 "USESARMAINDIREA." +
                 "ERATENBERALAVETI" +
                 "EDORQUANTEISRION";

	GOVERNMENT_NAMES = ["Anarchy", "Feudal", "Multi-gov", "Dictatorship",
                    "Communist", "Confederacy", "Democracy", "Corporate State"];

	ECONOMY_NAMES = ["Rich Ind", "Average Ind", "Poor Ind", "Mainly Ind",
                     "Mainly Agri", "Rich Agri", "Average Agri", "Poor Agri"];

	def initialize(seed)
		set_position(seed)
		set_government(seed)
		set_economy(seed)
		set_tech_level(seed)
		set_population(seed)
		set_productivity(seed)
		set_radius(seed)
		set_name(seed)
	end

	def to_s
		info = "System: #{@name}"
		info << "\nPosition (#{@x}, #{@y})"
		info << "\nEconomy: (#{@economy}) #{ECONOMY_NAMES[@economy]}"
		info << "\nGovernment: (#{@government}) #{GOVERNMENT_NAMES[@government]}"
		info << "\nTech Level: #{@tech_level + 1}"
		info << "\nTurnover: #{@productivity}"
		info << "\nRadius: #{@radius}"
		info << "\nPopulation: #{@population >> 3} Billion"
	end

	def calculate_distance(planet)
		x_dist = (x - planet.x).abs
		y_dist = (y - planet.y).abs

		Math.sqrt((x_dist ** 2) + (y_dist ** 2))
	end

	private

	def set_position(seed)
		@x = (seed.w1 >> 8).floor
		@y = (seed.w0 >> 8).floor
	end

	def set_government(seed)
		@government = ((seed.w1 >> 3) & 7).floor
	end

	def set_economy(seed)
		@economy = ((seed.w1 >> 3) & 7)
		@economy |= 2 if @government <= 1
	end

	def set_tech_level(seed)
		@tech_level = (((seed.w1 >> 8) & 0x03) + (@economy ^ 0x07)).floor + (@government >> 1)
		@tech_level += 1 if @government & 0x01
	end

	def set_population(seed)
		@population = 4 * @tech_level + @economy + @government + 1
	end

	def set_productivity(seed)
		((@economy ^ 0x07) + 3) * (@government + 4) * @population * 8
	end

	def set_radius(seed)
		256 * (((seed.w2 >> 8) & 0x0f) + 11) + x
	end

	def set_name(seed)
		long_name = seed.w0 & 0x40;

		pair1 = ((seed.w2 >> 8) & 0x1F) << 1
		seed.tweak

		pair2 = ((seed.w2 >> 8) & 0x1F) << 1
		seed.tweak

		pair3 = ((seed.w2 >> 8) & 0x1F) << 1
		seed.tweak

		pair4 = ((seed.w2 >> 8) & 0x1F) << 1
		seed.tweak

		@name = LETTER_PAIRS[pair1]
		@name << LETTER_PAIRS[pair1 + 1]
		@name << LETTER_PAIRS[pair2]
		@name << LETTER_PAIRS[pair2 + 1]
		@name << LETTER_PAIRS[pair3]
		@name << LETTER_PAIRS[pair3 + 1]

		if long_name
			@name << LETTER_PAIRS[pair4]
			@name << LETTER_PAIRS[pair4 + 1]
		end

		@name.gsub!('.', '')
	end

end