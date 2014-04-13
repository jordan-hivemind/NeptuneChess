# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@generatePlayerId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < 8
  id.substr 0, length

@chooseColor = (color) ->
	$.post(
		"/game/choose_color",
		{playerID: $.cookie("player_id"), color: color}
	)
	my_color = color

# do not pick up pieces if the game is over; only pick up pieces for the side to move
@onDragStart = (source, piece, position, orientation) ->
	if (game.game_over() == true || (game.turn() == 'w' && piece.search(/^b/) != -1) || (game.turn() == 'b' && piece.search(/^w/) != -1))
	  	return false;
  
@onDrop = (source, target, piece, newPos, oldPos, orientation) ->
	# see if the move is legal
  	move = game.move
    	from: source,
    	to: target,
    	promotion: 'q' # NOTE: always promote to a queen for example simplicity
  	
	# illegal move
	if (move == null) 
		return 'snapback'

	updateStatus()

	# Tell server
	$.post(
		"/game/move",
		{playerID: $.cookie("player_id"), source: source, target: target, fen: ChessBoard.objToFen(newPos)}
	)

# update the board position after the piece snap 
# for castling, en passant, pawn promotion
@onSnapEnd = () ->
	board.position(game.fen())