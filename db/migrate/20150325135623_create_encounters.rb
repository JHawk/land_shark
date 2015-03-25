class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|
      t.boolean :completed
      t.integer :location_id
      t.string  :name

      t.timestamps
    end
  end
end
