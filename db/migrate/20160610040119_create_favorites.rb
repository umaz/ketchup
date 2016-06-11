class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :count, :null => false, :default => 0

      t.timestamps null: false
    end
  end
end
