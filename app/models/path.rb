class Path < ActiveRecord::Base
  belongs_to :move
  has_many :coordinates, dependent: :destroy

  def primary_path
    # First coordinate in the path is the move source
    Coordinate.new.from_chess_coord(self, self.move.source).save

    unless self.move.piece == 'n'
      Coordinate.new.from_chess_coord(self, self.move.target).save
    else
      x = Coordinate.new.from_chess_coord(self, self.move.source).x
      y = Coordinate.new.from_chess_coord(self, self.move.source).y 

      # Half-step diagonal
      x = x + (Coordinate.new.from_chess_coord(self, self.move.target).x <=> x)
      y = y + (Coordinate.new.from_chess_coord(self, self.move.target).y <=> y)
      Coordinate.create(:x => x, :y => y, :path => self)

      # Full step on the long side
      x_movement = Coordinate.new.from_chess_coord(self, self.move.target).x - Coordinate.new.from_chess_coord(self, self.move.source).x
      y_movement = Coordinate.new.from_chess_coord(self, self.move.target).y - Coordinate.new.from_chess_coord(self, self.move.source).y
      x = x + (2 * (x_movement > y_movement ? 1 : 0) * (Coordinate.new.from_chess_coord(self, self.move.target).x <=> x))
      y = y + (2 * (x_movement > y_movement ? 0 : 1) * (Coordinate.new.from_chess_coord(self, self.move.target).y <=> y))
      Coordinate.create(:x => x, :y => y, :path => self)

      # Half-step diagonal
      x = x + (Coordinate.new.from_chess_coord(self, self.move.target).x <=> x)
      y = y + (Coordinate.new.from_chess_coord(self, self.move.target).y <=> y)
      Coordinate.create(:x => x, :y => y, :path => self)
    end
  end

  def remove_captured
    captured = Coordinate.new.from_chess.coord(self.move.target)

    is_white = !(/PNBRQK/.match(Node.find_by_x_and_y(x,y).occupant).blank?)

    # Check for en passant
    if self.move.flag == 'e'
      captured.y = captured.y + (2 * (is_white ? 1 : -1))
    end

    x = captured.x
    y = captured.y

    # First coordinate in the path is the location of the piece being taken
    self.coordinates.create(:x => x, :y => y)

    # Find an empty parking space
    parking_spots = is_white ? Coordinate.new.parking[:white] : Coordinate.new.parking[:black]

    i = 0
    while !(Node.find_by_x_and_y(parking_spots[i][:x], parking_spots[i][:y]).blank?)
      i = i +1
    end
    parking_target = Coordinate.new(:x => parking_spots[i][:x], :y => parking_spots[i][:y])

    # Move half-step towards the center
    y = 1 - (y <=> 4.5)
    self.coordinates.create(:x => x, :y => y)

    # Move to left edge if piece taken is white, right edge if black
    x = parking_target.x + (parking_target.x <=> x)
    self.coordinates.create(:x => x, :y => y)

    y = parking_target.y
    self.coordinates.create(:x => x, :y => y)

    self.coordinate.create(:x => parking_target.x, :y => y)
  end

  def castling
    # TODO
  end

  def promotion
    # TODO
  end
end