class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.string :kana
      t.string :about
      t.text :detail
      t.string :kind

      t.timestamps null: false
    end
  end
end
