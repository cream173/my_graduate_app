class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    recent_records = current_user.health_records.where(created_at: 7.days.ago.beginning_of_day..Time.current)
    
    @stress_avg = recent_records.average(:stress_level).to_f || 0
    @fatigue_avg = recent_records.average(:fatigue_level).to_f || 0
    @sleep_avg = recent_records.average(:sleep_level).to_f || 0

    @stress_percent = @stress_avg * 20.to_i
    @fatigue_percent = @fatigue_avg * 20.to_i
    @sleep_percent = @sleep_avg * 20.to_i

    if recent_records.exists?
      latest_feeling = recent_records.order(created_at: :desc).first.feeling
      weekly_symptom_names = Symptom.joins(:health_records)
                                    .where(health_records: { id: recent_records.pluck(:id) })
                                    .distinct
                                    .pluck(:name)

      @display_record = HealthRecord.new(
        stress_level: @stress_avg,
        fatigue_level: @fatigue_avg,
        sleep_level: @sleep_avg,
        feeling: latest_feeling
      )

      @weekly_symptom_names = weekly_symptom_names
    end

    def get_color(percent)
    if percent >= 80
      "#ef4444" # 赤
    elsif percent >= 60
      "#eab308" # 黄
    else
      "#5a6358" # 緑
    end

    @stress_color = get_color(@stress_percent)
    @fatigue_color = get_color(@fatigue_percent)
    @sleep_color = get_color(@sleep_percent)
  end
  end
end
