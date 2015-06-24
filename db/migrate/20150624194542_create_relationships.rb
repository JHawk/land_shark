class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :character_id, null: false
      t.integer :acquaintance_id, null: false
      t.integer :rating, null: false

      t.timestamps
    end
  end
end
