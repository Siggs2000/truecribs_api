class AddMlsNumToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :mls_num, :string
  end
end
