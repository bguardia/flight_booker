class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.references :from_airport_id, null: false, foreign_key: { to_table: :airports}
      t.references :to_airport_id, null: false, foreign_key: { to_table: :airports }
      t.datetime :departure_time
      t.datetime :arrival_time
      t.string :number

      t.timestamps
    end
  end
end
