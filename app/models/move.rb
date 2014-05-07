class Move < ActiveRecord::Base
	belongs_to :game
  has_many :paths, dependent: :destroy  
  after_create :c_paths

  def c_paths
    if self.flag == 'c' || self.flag == "e"
      self.paths.create.remove_captured
    end

    self.paths.create.primary_path

    if self.flag == 'k' || self.flag == 'q'
      self.paths.create.castling
    end

    if self.flag == 'p'
      sef.paths.create.promotion
    end
  end
end
