class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :project_id
      t.text :word
      t.integer :tfidf

      t.timestamps null: false
    end
  end
end
