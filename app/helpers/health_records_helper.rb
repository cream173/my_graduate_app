module HealthRecordsHelper
  def feeling_icon(value)
    case value
    when 1 then "😌" # おだやか
    when 2 then "😆" # 楽しい
    when 3 then "🙂" # ふつう
    when 4 then "😞" # しんどい
    when 5 then "😡" # イライラ
    else ""
    end
  end

  def feeling_label(value)
    labels = { 1 => "おだやか", 2 => "楽しい", 3 => "ふつう", 4 => "しんどい", 5 => "イライラ" }
    labels[value] || "記録なし"
  end
end
