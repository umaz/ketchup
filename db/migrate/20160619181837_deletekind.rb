class Deletekind < ActiveRecord::Migration
  def up
    remove_column :projects, :kind
    remove_column :entries, :kind
  end

  def down
    add_column :projects, :kind, :string
    add_column :entries, :kind, :string
  end
end
