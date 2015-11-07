class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.integer :answer_id
      t.integer :user_id
      t.integer :question_id

      t.timestamps null: false
    end
  end
end
