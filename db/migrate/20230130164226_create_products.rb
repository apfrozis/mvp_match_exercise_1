class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, unique: true
      t.integer :amount_available
      t.integer :cost
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
