class ChangeTfidfToTfidf < ActiveRecord::Migration
  def up
    change_column :searches, :tfidf, :float
  end

  #変更前の型
  def down
    change_column :searches, :tfidf, :intger
  end
end
