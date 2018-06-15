class Deletekind < ActiveRecord::Migration[4.2]
  def up
    remove_column :projects, :kind
    remove_column :entries, :kind
  end

  def down
    add_column :projects, :kind, :string
    add_column :entries, :kind, :string
  end
end
