class AddQuestNumToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :quest_num, :integer
  end
end
