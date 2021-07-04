class ChangeForeignKeyNamesInFlights < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :flights, column: :from_airport_id_id
    remove_foreign_key :flights, column: :to_airport_id_id
    remove_column :flights, :from_airport_id_id
    remove_column :flights, :to_airport_id_id
    
    add_column :flights, :from_airport_id, :bigint
    add_column :flights, :to_airport_id, :bigint
    add_foreign_key :flights, :airports, column: :from_airport_id
    add_foreign_key :flights, :airports, column: :to_airport_id
  end
end
