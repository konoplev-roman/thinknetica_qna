class AddUserToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :user, foreign_key: true, null: false
  end
end
