class CreateHealthRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :health_records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :recorded_at
      t.integer :feeling
      t.integer :fatigue_level
      t.integer :stress_level
      t.integer :sleep_level
      t.text :memo

      t.timestamps
    end
  end
end
