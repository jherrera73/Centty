class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :user_id
      t.boolean :response

      t.timestamps
    end
    add_index :answers, :question_id
  end
end
