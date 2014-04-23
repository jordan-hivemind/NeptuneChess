class CreateDb < ActiveRecord::Migration
  def change
    create_table :games do |g|
      g.string :fen
      g.string :white
      g.string :black
      g.boolean :active
      g.datetime :started_at
      g.datetime :last_move_at
      g.timestamps
    end

    create_table :moves do |m|
      m.integer :game_id
      m.string :source
      m.string :target
      m.string :flag
      m.string :piece
      m.timestamps
    end

    create_table :nodes do |t|
      t.integer :x
      t.integer :y
      t.string :occupant
      t.timestamps
    end

    create_table :paths do |p|
      p.belongs_to :move
      p.boolean :processed
      p.timestamps
    end

    create_table :coordinates do |c|
      c.belongs_to :path
      c.integer :x
      c.integer :y
      c.timestamps
    end
  end
end