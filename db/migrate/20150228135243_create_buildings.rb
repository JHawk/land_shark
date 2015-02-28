class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.belongs_to :location, index: true

      t.timestamps
    end
  end
end
