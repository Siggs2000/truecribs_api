class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :wins
      t.integer :losses
      t.integer :points

      t.timestamps null: false
    end
  end
end
