class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :role
      t.string :username, unique: true
      t.string :password_digest
      t.integer :deposit, default: 0


      t.timestamps
    end
  end
end
