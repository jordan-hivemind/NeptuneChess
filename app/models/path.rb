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
    # First coordinate in the path is the location of the piece being taken
    Coordinate.new.from_chess_coord(self, self.move.target).save

    x = Coordinate.new.from_chess_coord(self, self.move.target).x
    y = Coordinate.new.from_chess_coord(self, self.move.target).y

    is_white = !(/PNBRQK/.match(Node.find_by_x_and_y(x,y).occupant).nil?)

    # Move half-step towards the center
    y = 1 - (y <=> 4.5)
    Coordinate.create(:x => x, :y => y, :path => self)

    # Move to left edge if piece taken is white, right edge if black
    x = 3 if is_white else x = 19
    Coordinate.create(:x => x, :y => y, :path => self)

    # TODO: Find empty parking square and move to it
  end

  def en_passant
    # TODO
  end

  def castling
    # TODO
  end

  def promotion
    # TODO
  end
end