class Coordinate < ActiveRecord::Base
  belongs_to :path

  def from_chess_coord(path, chess_coord)
    files = ["a", "b", "c", "d", "e", "f", "g", "h"]
    self.path = path
    self.x = (files.index(chess_coord[0]) * 2 + 4)
    self.y = (chess_coord[1].to_i - 1) * 2

    return self
  end
end