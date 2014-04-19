class GameController < ApplicationController
	def index
		# Check if there's a game going on, create one if there isn't
		player_id = params["playerId"]
		move = ""
		game = Game.find_by_active(true)
		if game.nil?
			game = Game.create(:fen => Game::START_FEN, :active => true)
		end
		puts game.fen
		if game.computer_turn?
			move = Stockfish.new.move(game)
			puts move
			Move.create(:source => move[0,2], :target => move[2,2], :game => game)
		end
		render(json: 
			{
				id: game.id,
				fen: game.fen, 
				seats: {
					white: Game.new.report_seat(game.white, player_id),
					black: Game.new.report_seat(game.black, player_id)
				},
				moves: game.moves
			})
	end

	def choose_seat
		@game = Game.find_by_active(true)
		if !(params["white"].blank?)
			@game.update_attribute(:white, params["white"])
		elsif !(params["black"].blank?)
			@game.update_attribute(:black, params["black"])
		else 
			render(json: {error: "missing data"})
			return
		end
		render nothing: true
	end

	def move
		@game = Game.find_by_active(true)
		# TODO: Check for legal
		Move.create(:source => params["source"], :target => params["target"], :game => @game)
		@game.update_attribute(:fen, params["fen"])
		render nothing: true
	end

	def end
		Game.find_by_active(true).update_attribute(:active, false)
		render nothing: true
	end

	def destroy
		@game = Game.last
		if (playerId == @game.white || playerId == @game.black)
			@game.destroy
			render nothing: true
		else
			render(json: {}, :status => :unauthorized)
		end
	end
end