class CreateEntries < ActiveRecord::Migration[4.2]
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
