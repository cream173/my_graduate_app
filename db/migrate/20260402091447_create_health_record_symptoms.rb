class CreateHealthRecordSymptoms < ActiveRecord::Migration[8.0]
  def change
    create_table :health_record_symptoms do |t|
      t.references :health_record, null: false, foreign_key: true
      t.references :symptom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
