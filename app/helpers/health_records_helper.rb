module HealthRecordsHelper
  def feeling_icon(value)
    case value
    when 1 then "😊" # ごきげん
    when 2 then "🙂" # ふつう
    when 3 then "😔" # 不安
    when 4 then "😢" # しんどい
    when 5 then "😡" # イライラ
    else ""
    end
  end

  def feeling_label(value)
    labels = { 1 => "ごきげん", 2 => "ふつう", 3 => "不安", 4 => "しんどい", 5 => "イライラ" }
    labels[value] || "記録なし"
  end
end
