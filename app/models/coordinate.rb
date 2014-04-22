class Coordinate < ActiveRecord::Base
  belongs_to :path

  def parking
    p = {white: [], black: []}

    for x in 0..1
      for y in 0..8
        p[:white] << {x: x*2, y: y*2}
      end
    end

    for x in 10..11
      for y in 0..8
        p[:black] << {x: x*2, y: y*2}
      end
    end      
  end

  def from_chess_coord(chess_coord)
    files = ["a", "b", "c", "d", "e", "f", "g", "h"]
    self.x = (files.index(chess_coord[0]) * 2 + 4)
    self.y = (chess_coord[1].to_i - 1) * 2

    return self
  end
end