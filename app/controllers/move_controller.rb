class MoveController < ApplicationController
  def create
    @game = Game.find_by_active(true)
    # TODO: Check for legal
    Move.create(:source => params["source"], :target => params["target"], :game => @game)
    @game.update_attribute(:fen, params["fen"])
    render nothing: true
  end
end
