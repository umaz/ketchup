class Pre < ActiveRecord::Migration
  def change
    remove_column :Entries, :group, :string
    remove_column :Entries, :about, :text
    remove_column :Projects, :group, :string
    remove_column :Projects, :about, :text
    add_column :Entries, :kana, :string
    add_column :Entries, :about, :string
    add_column :Entries, :detail, :text
    add_column :Projects, :kana, :string
    add_column :Projects, :about, :string
    add_column :Projects, :detail, :text
  end
end
