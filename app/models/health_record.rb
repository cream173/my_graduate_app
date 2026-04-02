class HealthRecord < ApplicationRecord
  belongs_to :user
  has_many :health_record_symptoms, dependent: :destroy
  has_many :symptoms, through: :health_record_symptoms
end
