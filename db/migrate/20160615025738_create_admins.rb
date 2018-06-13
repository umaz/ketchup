class CreateAdmins < ActiveRecord::Migration[4.2]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :password

      t.timestamps null: false
    end
  end
end
