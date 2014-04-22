class Move < ActiveRecord::Base
	belongs_to :game
  has_many :paths, dependent: :destroy  
  after_create :create_paths

  def create_paths
    if self.flag == 'c' || self.flag == "e"
      Path.create(:move => self).remove_captured()
    end

    Path.create(:move => self).primary_path()

    if self.flag == 'e'
      Path.create(:move => self).en_passant()
    end

    if self.flag == 'k' || self.flag == 'q'
      Path.create(:move => self).castling()
    end

    if self.flag == 'p'
      Path.create(:move => self).promotion()
    end
  end
end
