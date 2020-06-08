class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :voteable, polymorphic: true, null: false
      t.integer :value, null: false

      t.timestamps

      t.index [:user_id, :voteable_id, :voteable_type], unique: true
    end
  end
end
