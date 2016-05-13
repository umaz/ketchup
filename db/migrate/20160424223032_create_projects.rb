class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :group
      t.text :about
      t.string :kind

      t.timestamps null: false
    end
  end
end
