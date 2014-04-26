class GameController < ApplicationController
	def index
		# Check if there's a game going on, create one if there isn't
		player_id = params["playerId"]
		move = ""
		game = Game.find_by_active(true)
		if game.nil?
			game = Game.create(:fen => Game::START_FEN, :active => true)
		end
		if game.computer_turn?
			move = stockfish_move(game)
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

	def set_fen
		game = Game.find_by_active(true)
		if params["fen"]
			game.update_attribute(:fen, params["fen"])
		end
		render nothing: true
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

	def stockfish_move(game)
    stdin, stdout, stderr = Open3.popen3('~/dev/NeptuneChess/bin/stockfish')
    stdin.puts("uci")
    stdin.puts("option name Hash type spin default 1 min 1 max 128")
    stdin.puts("position fen " + game.fen)
    stdin.puts("option name Style type combo default Normal var Solid var Normal var Risky")
    stdin.puts("go depth 10")
    sleep(1)
    stdin.close
    result = stdout.read
    return /bestmove.*/.match(result).to_s.split[1]
  end
end