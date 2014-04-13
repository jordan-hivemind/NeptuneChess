class CreateDb < ActiveRecord::Migration
  def change
    create_table :games do |g|
      g.string :fen
      g.string :white
      g.string :black
      g.datetime :started_at
      g.datetime :last_move_at
      g.timestamps
    end

    create_table :moves do |m|
      m.integer :game_id
      m.string :source
      m.string :target
      m.timestamps
    end
  end
end