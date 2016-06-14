class Fav < ActiveRecord::Migration
  def change
    add_column :Projects, :count, :integer, :null => false, :default => 0
  end
end
