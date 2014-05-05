class Node < ActiveRecord::Base
  def create_from_fen(fen)
    i = 0
    y = 0
    while y < 15
      x = 0
      while x < 23
        if x < 4 || x > 18 || (x % 2 == 1) || (y % 2 == 1)
          Node.create(:x => x, :y => y, :occupant => "")
        else
          if !(/\d/.match(fen[i]))
            Node.create(:x => x, :y => y, :occupant => fen[i])
          else
            for skip in 0..((fen[i].to_i * 2) - 1)
              Node.create(:x => x, :y => y, :occupant => "")
              x += 1
            end
            x -= 1
          end
          i += 1
        end
        x += 1
      end
      y += 1
      # Skip the slash
      i=i+1 if (y % 2 == 0)
    end
  end
end