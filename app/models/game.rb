class Game < ActiveRecord::Base
	has_many :moves, dependent: :destroy
	has_many :paths, through: :moves

	START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

	def turn
		if self.moves.nil? || (self.moves.length % 2 == 0)
			return "w"
		else
			return "b"
		end
	end

	def report_seat(seat, playerId)
		if seat.nil?
			return nil
		elsif seat == playerId
			return "self"
		elsif seat == "computer"
			return "computer"
		else
			return "human"
		end
	end

	def user_color(playerID)
		if self.white == playerID
			return "white"
		elsif self.black == playerID
			return "black"
		else
			return nil
		end
	end

	def computer_turn?
		if (self.turn == 'w' && self.white == "computer") || (self.turn == 'b' && self.black == "computer")
			return true
		else
			return false
		end
	end
end