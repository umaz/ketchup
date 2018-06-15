class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :kana
      t.string :about
      t.text :detail
      t.string :kind
      t.integer :count

      t.timestamps null: false
    end
  end
end
