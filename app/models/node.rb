class Node < ActiveRecord::Base
  
  def create_from_fen(fen)
    i = 0
    x = 0
    y = 0
    for y in 0..14
      for x in 0..22
        if x < 4 || x > 18 || (x % 2 == 1) || (y % 2 == 1)
          Node.create(:x => x, :y => y, :occupant => "")
        else
          if !(/\d/.match(fen[i]))
            Node.create(:x => x, :y => y, :occupant => fen[i])
          else
            for skip in 0..(fen[i].to_i - 1)
              Node.create(:x => x + skip, :y => y, :occupant => "")
            end
            x = x + fen[i].to_i - 1
          end
          i=i+1
          puts "I is " + i.to_s
        end
      end
      i=i+1
    end
  end
end