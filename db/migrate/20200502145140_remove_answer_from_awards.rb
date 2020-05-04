class RemoveAnswerFromAwards < ActiveRecord::Migration[5.2]
  def change
    remove_reference :awards, :answer, index:true, foreign_key: true
  end
end
