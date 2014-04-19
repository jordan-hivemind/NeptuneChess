class Player
  constructor: () ->
    @id = $.cookie("player_id")
    if (!@id)
      @id = generateId()
      $.cookie("player_id", @id)
    @seats = []

  generateId = (length=8) =>
    @id = ""
    @id += Math.random().toString(36).substr(2) while @id.length < 8
    @id.substr 0, length

window.Player = Player