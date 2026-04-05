class HealthRecord < ApplicationRecord
  belongs_to :user
  has_many :health_record_symptoms, dependent: :destroy
  has_many :symptoms, through: :health_record_symptoms

  validates :feeling, presence: true
  validates :fatigue_level, presence: true
  validates :stress_level, presence: true
end
