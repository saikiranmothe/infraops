class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, limit: 255
      t.string :email, limit: 255
      t.string :username, limit: 255
      t.text :biography
      t.string :status, limit: 55

      t.string :password_digest
      t.string :auth_token

      t.timestamps
    end
  end
end
