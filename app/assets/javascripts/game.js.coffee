class Game
  constructor: (@player) ->
    @hand_on_piece = false
    @move_checker = new Chess
    @board = new ChessBoard 'board', {
      position: "start",
      draggable: true,
      onDrop: @onDrop,
      onDragStart: @onDragStart,
      onSnapEnd: @onSnapEnd,
      showNotation: false,
      pieceTheme: '/images/chesspieces/alpha/{piece}.png'
      }
    
  update: () =>
    return true if @hand_on_piece
    $.get "/game", { playerId: @player.id }, (data) =>
      @player.color = data["user_color"]
      if data["seats_available"].length == 0
        console.log(@player.color)
        @board.orientation(@player.color)
        
        # Hide side selection
        $(".choose_seat").addClass("hidden")
        
        # Update local fen to server fen
        if !(data["fen"] == @board.position)
          @board.position(data["fen"])
          @move_checker.load(data["fen"])
          $(".choose_seat").addClass("hidden")
        
        @board.draggable = (@player.color == data["turn"])
      
      else
        # otherwise, mark seats available
        data["seats_available"].forEach (seat) =>
          $("#choose_"+seat).removeClass("disabled")
          $("#choose_"+seat).bind "click", () =>
            $.post "/game/choose_color", { playerId: @player.id, color: seat}
            $("#choose_"+seat).addClass("disabled")
            $("#choose_"+seat).unbind("click")
        for button, index in $(".choose_seat")
          if data["seats_available"].indexOf(button.title) == -1 
            $("#" + button.id).addClass("disabled")
            $("#" + button.id).unbind("click")

  onDragStart: (source, piece, position, orientation) =>
    @hand_on_piece = true
    if @move_checker.game_over() == true || (@move_checker.turn() == 'w' && piece.search(/^b/) != -1) || (@move_checker.turn() == 'b' && piece.search(/^w/) != -1) || (@player.color[0] != @move_checker.turn())
      false
    true

  onDrop: (source, target, piece, newPos, oldPos, orientation) =>
    @hand_on_piece = false
    # see if the move is legal
    move = @move_checker.move
      from: source,
      to: target,
      promotion: 'q' # NOTE: always promote to a queen for example simplicity
      
    # illegal move
    if (move == null) 
      return 'snapback'

    @board.draggable = false

    # Tell server
    $.post(
      "/game/move",
      {playerId: @player.id, source: source, target: target, fen: @move_checker.fen()})

  onSnapEnd: () =>
    @board.position(@move_checker.fen())

window.Game = Game