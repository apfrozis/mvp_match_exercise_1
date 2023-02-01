class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :token
      t.date :expiration_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
