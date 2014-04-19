class WelcomeController < ApplicationController
  def index
  	
    stdin, stdout, stderr = Open3.popen3('~/dev/NeptuneChess/app/assets/stockfish')
    stdin.puts("uci")
    stdin.puts("position fen rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
    stdin.puts("go")
    stdin.close
    result = stdout.read
    @move = /bestmove.*/.match(result).to_s.split[1]
  	session[:signed_in_at] = DateTime.now() if(session[:signed_in_at].nil?) 
  end

  def change
  	puts params
  	render(json: {new_pos: "r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R"})
  end
end