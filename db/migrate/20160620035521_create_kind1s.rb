class CreateKind1s < ActiveRecord::Migration
  def change
    create_table :kind1s do |t|
      t.string :kind1

      t.timestamps null: false
    end
  end
end
