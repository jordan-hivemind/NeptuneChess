class GameController < ApplicationController
	def index
		# Check if there's a game going on, create one if there isn't
		@game = Game.last
		if @game.nil?
			@game = Game.create(:fen => Game::START_FEN)
		end
		render(json: {fen: @game.fen, turn: @game.turn, seats_available: @game.seats_available, user_color: @game.user_color(params["playerID"])})
	end

	def choose_color
		puts params["playerID"]
		@game = Game.last
		if params["color"] == "white"
			@game.update_attribute(:white, params["playerID"])
		else
			@game.update_attribute(:black, params["playerID"])
		end
		render nothing: true
	end

	def move
		@game = Game.last
		# TODO: Check for legal
		Move.create(:source => params["source"], :target => params["target"], :game => @game)
		@game.update_attribute(:fen, params["fen"])
		render nothing: true
	end
end