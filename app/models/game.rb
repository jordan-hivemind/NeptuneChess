class Game < ActiveRecord::Base
	has_many :moves, dependent: :destroy

	START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

	def turn
		if self.moves.nil? || (self.moves.length % 2 == 0)
			return "white"
		else
			return "black"
		end
	end

	def seats_available
		s = []
		if self.white.nil?
			s << "white"
		end
		if self.black.nil?
			s << "black"
		end
		return s
	end

	def user_color(playerID)
		if self.white == playerID
			return "white"
		elsif self.black == playerID
			return "black"
		else
			return null
		end
	end
end