class HealthRecordSymptom < ApplicationRecord
  belongs_to :health_record
  belongs_to :symptom
end
