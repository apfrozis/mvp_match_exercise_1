class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :role
      t.string :username
      t.string :password
      t.integer :deposit, default: 0


      t.timestamps
    end
  end
end
