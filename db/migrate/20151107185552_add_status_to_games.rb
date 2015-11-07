class AddStatusToGames < ActiveRecord::Migration
  def change
    add_column :games, :status, :string, :default => "active"
  end
end
