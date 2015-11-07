class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.text :body
      t.boolean :correct
      t.string :image

      t.timestamps null: false
    end
  end
end
