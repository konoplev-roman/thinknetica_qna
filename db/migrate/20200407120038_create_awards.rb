class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :title, null: false
      t.references :question, foreign_key: true, null: false
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
