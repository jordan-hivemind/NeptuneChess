class Game
  constructor: () ->
    @id = ""
    # If the user has no player id, create one
    @player = new Player
    
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
    $.get "/game", { playerId: @player.id, id: @id }, (data) =>
      if data["moves"].length > @move_checker.history( {verbose: true} ).length
        # More moves on server than client
        for move in data["moves"].slice @move_checker.history( {verbose: true}).length
          @makeMove move
        $.post "/game", {fen: @move_checker.fen()}
        $(".choose_white.button").addClass "hidden"
        $(".choose_black.button").addClass "hidden"
      
      else if data["seats"]["white"] == null || data["seats"]["black"] == null
        # There are seats available
        if data["seats"]["white"] == null
          $(".choose_white").removeClass "hidden"
        else
          $(".choose_white").addClass "disabled"
          $(".choose_white").unbind()

        if data["seats"]["black"] == null
          $(".choose_black").removeClass "hidden"
        else
          $(".choose_black").addClass "disabled"
          $(".choose_black").unbind()

      else
        if @id == ""
          # both sides claimed, new game
          @id = data["id"]
          
          @player.seats.push('w') if data["seats"]["white"] == "self"
          @player.seats.push('b') if data["seats"]["black"] == "self"

          @board.orientation("black") if @player.seats.indexOf('b') != -1 && @player.seats.indexOf('w') == -1

          $(".choose_white.button").addClass "hidden"
          $(".choose_black.button").addClass "hidden"
        
          # Reset board
          @board.position(data["fen"])
          @move_checker.reset

  onDragStart: (source, piece, position, orientation) =>
    @hand_on_piece = true
    if @move_checker.game_over() == true || (@move_checker.turn() == 'w' && piece.search(/^b/) != -1) || (@move_checker.turn() == 'b' && piece.search(/^w/) != -1) || (@player.seats.indexOf(@move_checker.turn()) == -1)
      false
    true

  onDrop: (source, target, piece, newPos, oldPos, orientation) =>
    @hand_on_piece = false
    if @player.seats.indexOf(@move_checker.turn()) == -1
      return 'snapback'

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
    # @writeMovetoScreen move
    $.post "/move", {playerId: @player.id, source: source, target: target, fen: @move_checker.fen()}

  onSnapEnd: () =>
    @board.position(@move_checker.fen())

  makeMove: (move) =>
    # TODO: Validate server move
    @move_checker.move {from: move["source"], to: move["target"]}
    @board.position @move_checker.fen()
    # @writeMovetoScreen move

  writeMovetoScreen: (move) =>
    if @move_checker.turn() == 'w'
      $("#moves").append "<tr><td>" + move["source"] + "-" + move["target"] + "</td></tr>"
    else
      $("#moves tr:last").append "<td>" + move["source"] + "-" + move["target"] + "</td>"

window.Game = Game