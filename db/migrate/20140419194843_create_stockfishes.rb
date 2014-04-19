class CreateStockfishes < ActiveRecord::Migration
  def change
    create_table :stockfishes do |t|

      t.timestamps
    end
  end
end
