class Addcolumnprojects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :synonym, :string
    add_column :projects, :kind1, :string
    add_column :projects, :kind2, :string
    add_column :entries, :synonym, :string
    add_column :entries, :kind1, :string
    add_column :entries, :kind2, :string
  end
end
