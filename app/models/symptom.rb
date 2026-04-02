class Symptom < ApplicationRecord
  has_many :health_record_symptoms, dependent: :destroy
  has_many :health_records, through: :health_record_symptoms
end
