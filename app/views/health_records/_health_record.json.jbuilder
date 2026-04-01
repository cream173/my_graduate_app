json.extract! health_record, :id, :user_id, :recorded_at, :feeling, :fatigue_level, :stress_level, :sleep_level, :memo, :created_at, :updated_at
json.url health_record_url(health_record, format: :json)
