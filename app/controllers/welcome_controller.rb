class WelcomeController < ApplicationController
  def index
  	@directory = `ls -l`
  	session[:signed_in_at] = DateTime.now() if(session[:signed_in_at].nil?) 
  end

  def change
  	puts params
  	render(json: {new_pos: "r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R"})
  end
end