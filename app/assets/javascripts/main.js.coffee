# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.my_color = ""

initializeBoard = () ->
  $.get "/game", {playerID: playerID},
    (data) ->
      window.my_color = data["user_color"]
      if (data["seats_available"].length > 0)
        # If seat(s) are available, offer one to the user
        data["seats_available"].forEach (seat) ->
          $("#choose_"+seat).removeClass("disabled")
          $("#choose_"+seat).bind("click", () -> 
            $.post "/game/choose_color", {playerID: $.cookie("player_id"), color: @.title}
            $("#choose_"+seat).addClass("disabled")
            $("#choose_"+seat).unbind("click")
            window.my_color = seat)
      else 
        # Display board
        $(".choose_seat").addClass("hidden")
        game.load(data["fen"])
        board.position(data["fen"])
        if window.my_color != data["turn"]
          board.draggable = false
        board.orientation(window.my_color)
window.initializeBoard = initializeBoard

generatePlayerId = (length=8) ->
  id = ""
  id += Math.random().toString(36).substr(2) while id.length < 8
  id.substr 0, length
window.generatePlayerId = generatePlayerId

# do not pick up pieces if the game is over; only pick up pieces for the side to move
onDragStart = (source, piece, position, orientation) ->
  if (game.game_over() == true || (game.turn() == 'w' && piece.search(/^b/) != -1) || (game.turn() == 'b' && piece.search(/^w/) != -1) || (window.my_color[0] != game.turn()))
    false;
window.onDragStart = onDragStart

onDrop = (source, target, piece, newPos, oldPos, orientation) ->
  # see if the move is legal
  move = game.move
    from: source,
    to: target,
    promotion: 'q' # NOTE: always promote to a queen for example simplicity
    
  # illegal move
  if (move == null) 
    return 'snapback'

  updateStatus()

  board.draggable = false

  # Tell server
  $.post(
    "/game/move",
    {playerID: $.cookie("player_id"), source: source, target: target, fen: game.fen()})
window.onDrop = onDrop

@updateStatus = () ->
  status = ''

  moveColor = 'White'
  if (game.turn() == 'b') 
    moveColor = 'Black'

  # checkmate?
  if (game.in_checkmate() == true)
    status = 'Game over, ' + moveColor + ' is in checkmate.'

  # draw?
  else if (game.in_draw() == true)
    status = 'Game over, drawn position'

  # game still on
  else 
    status = moveColor + ' to move'
    # check?
    if (game.in_check() == true)
      status += ', ' + moveColor + ' is in check'

# update the board position after the piece snap for castling, en passant, pawn promotion
onSnapEnd = () ->
  board.position(game.fen())
window.onSnapEnd = onSnapEnd