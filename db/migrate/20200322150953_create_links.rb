class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.references :linkable, polymorphic: true, null: false

      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
