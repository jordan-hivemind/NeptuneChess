class Stockfish < ActiveRecord::Base
def move(game)
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
