module HealthRecordsHelper
  def feeling_icon(value)
    case value
    when 1 then "😊" # リラックス
    when 2 then "😄" # 楽しい
    when 3 then "😐" # ふつう
    when 4 then "😥" # 落ち込み
    when 5 then "😡" # イライラ
    else ""
    end
  end

  def feeling_label(value)
    labels = { 1 => "リラックス", 2 => "楽しい", 3 => "ふつう", 4 => "落ち込み", 5 => "イライラ" }
    labels[value] || "不明"
  end
end
