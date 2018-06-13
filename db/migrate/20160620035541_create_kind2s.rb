class CreateKind2s < ActiveRecord::Migration[4.2]
  def change
    create_table :kind2s do |t|
      t.integer :kind1_id
      t.string :kind2

      t.timestamps null: false
    end
  end
end
