class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :mls_num
      t.string :list_agent
      t.integer :list_price_over, :default => 0
      t.integer :list_price_under, :default => 0
      t.integer :recognizable, :default => 0
      t.integer :current_trends, :default => 0

      t.timestamps null: false
    end
  end
end
