class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.string :group
      t.text :about
      t.string :kind

      t.timestamps null: false
    end
  end
end
