class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    recent_records = current_user.health_records.where(created_at: 7.days.ago.beginning_of_day..Time.current)
    
    @stress_avg = recent_records.average(:stress_level).to_i || 0
    @fatigue_avg = recent_records.average(:fatigue_level).to_i || 0
    @sleep_avg = recent_records.average(:sleep_level).to_i || 0

    @stress_percent = @stress_avg * 20
    @fatigue_percent = @fatigue_avg * 20
    @sleep_percent = @sleep_avg * 20


    def get_color(percent)
    if percent >= 80
      "#ef4444" # 赤 (Tailwindの red-500)
    elsif percent >= 60
      "#eab308" # 黄 (Tailwindの yellow-500)
    else
      "#5a6358" # 通常時の緑/石色
    end

    @stress_color = get_color(@stress_percent)
    @fatigue_color = get_color(@fatigue_percent)
    @sleep_color = get_color(@sleep_percent)
  end
  end
end
