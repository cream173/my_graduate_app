class HealthRecord < ApplicationRecord
  belongs_to :user
  has_many :health_record_symptoms, dependent: :destroy
  has_many :symptoms, through: :health_record_symptoms

  validates :feeling, presence: true
  validates :fatigue_level, presence: true
  validates :stress_level, presence: true
  validate :once_per_day, on: :create

  def kampo_advice(manual_symptoms = nil)

    # 選択された症状の名前を配列で取得
    s_names = manual_symptoms || symptoms.pluck(:name)

    # ---------------------------------------------------------
    # 気分 × 体調 パターン
    # ---------------------------------------------------------

    # --- イライラ・ストレス系 (気滞・気逆) ---
    if feeling == 5 || stress_level >= 4
      if s_names.intersect?(["頭痛", "のぼせ"])
        return {
          type: "気逆（きぎゃく）",
          message: "頭を使いすぎて、エネルギーが上に渋滞しているかもしれません。今は難しいことは考えずに、ミントの香りでリフレッシュしたり、足元を温めて高ぶりを下に降ろしてあげるのもよいでしょう",
          foods: "トマト、セロリ、ピーマン、レタス、緑茶"}
      elsif s_names.intersect?(["胃のむかつき", "便秘"])
        return {
          type: "気滞（きたい）",
          message: "ストレスが胃腸の動きを邪魔しているのかもしれません。シトラス系の香りで巡りを整え、軽くお散歩してリフレッシュするのもよいでしょう",
          foods: "玉ねぎ、みかん、グレープフルーツ、しそ、三つ葉"}
      elsif s_names.include?("肩こり")
        return { 
          type: "気滞 + 瘀血",
          message: "緊張で血の流れがギュッと止まりがちかもしれません。深呼吸をして肩の力を抜き、まずは心をゆるめる時間をつくってみましょう。",
          foods: "チンゲン菜、パセリ、お酢、らっきょう、なす"
        }
      end
    end

    # --- 不安・眠れない系 (血虚) ---
    if feeling == 3 || sleep_level >= 4
      if s_names.intersect?(["目の疲れ", "めまい"])
        return {
          type: "血虚（けっきょ）",
          message: "栄養が目や脳まで届かず、少しお疲れ気味のようです。夜は早めに照明を落とし、スマホをお休みして暗闇の中で心と目をじっくり休ませてみるのはいかがでしょう。",
          foods: "にんじん、ほうれん草、小松菜、黒ごま、卵"}
      elsif s_names.intersect?(["乾燥", "便秘"])
        return {
          type: "血虚 + 津液不足",
          message: "体も心も少しうるおいが足りない状態かもしれません。お風呂上がりに丁寧に保湿したり、温かい飲み物をゆっくり一口ずつ飲んで、ゆったり過ごしてみましょう。",
          foods: "豆腐、豆乳、白ごま、はちみつ、こんにゃく"}
      elsif s_names.intersect?(["冷え", "肩こり"])
        return { 
          type: "血虚 + 瘀血", 
          message: "血の巡りが滞り体が冷えやすい状態のようです。足首を回したり足湯をしたりして下半身からぽかぽかと温めて巡る力を応援してあげましょう。",
          foods: "いわし、さば、ドライプルーン、小豆、レバー"}
      end
    end

    # --- しんどい・無気力系 (気虚) ---
    if feeling == 4 || fatigue_level >= 4
      if s_names.intersect?(["食欲不振", "お腹がゆるい", "胃のむかつき"])
        return { 
          type: "脾気虚（ひききょ）", 
          message: "胃腸のエネルギーが落ち、少しバテてしまっているようです。今は無理に食べず消化の良いものを少しずつとってお腹の中を温めて元気をためましょう。",
          foods: "かぼちゃ、さつまいも、じゃがいも、キャベツ、しょうが"}
      elsif s_names.intersect?(["むくみ", "体が重い"])
        return { 
          type: "気虚 + 水滞", 
          message: "頑張りすぎて、体内の水の巡りが弱まっているかもしれません。足の下にクッションを置いて少し高くして眠るなど、自分を一番に労ってあげてくださいね。",
          foods: "枝豆、とうもろこし、大豆(水煮)、きのこ、長いも"
          }
      elsif s_names.intersect?(["めまい", "頭痛"])
        return { 
          type: "気虚 + 巡り不足",
          message: "脳までパワーが届かず、フラフラしやすいサインかもしれません。大きく鼻から吸って口から補足長く吐き出す深呼吸をして、新しい空気を体いっぱいに取り込みましょう。",
          foods: "鶏肉、しいたけ、くるみ、ブロッコリー、バナナ"}
      end
    end

    # ---------------------------------------------------------
    # 気になる症状のみのパターン
    # ---------------------------------------------------------

    # 水滞（すいたい）
    if s_names.intersect?(["むくみ", "体が重い", "頭痛", "お腹がゆるい"])
      return { 
        type: "水滞（すいたい）", 
        message: "余分な水分が溜まり、体が重だるくなっているかもしれません。冷たいものを少し控えてゆっくり湯船に浸って汗を流し、体のお掃除をしてみましょう。",
        foods: "きゅうり、もやし、わかめ、あさり、ごぼう"}
    end

    # 瘀血（おけつ）
    if s_names.intersect?(["肩こり", "冷え", "便秘", "頭痛"])
      return { 
        type: "瘀血（おけつ）", 
        message: "血の巡りが滞り、体にコリや重さを感じやすい状態かもしれません。湯船にゆっくり浸ったり、かかとの上げ下げ運動をするだけでも巡りは変わります。意識的に動く時間を作ってみてもよいでしょう。",
        foods: "納豆、ニラ、青魚、黒酢、にんにく、玉ねぎ"}
    end

    # ---------------------------------------------------------
    # 必須項目の数値のみのパターン
    # ---------------------------------------------------------

    if feeling == 5 || stress_level >= 3
      return { 
        type: "気滞", 
        message: "少し心が波立っているようです。5分だけ好きな音楽を聴いたり、窓を開けて空を眺めたりして、心のモヤモヤを風に流してしまいましょう。",
        foods: "大根、梅干し、ジャスミン茶、パクチー、レモン"}
    end

    if feeling == 4 || fatigue_level >= 3
      return { 
        type: "気虚", 
        message: "エネルギーの充電が必要なサインです。今日はいつもより少しだけ早くお布団に入って、ゆっくり休んでくださいね。",
        foods: "お米、鶏むね肉、豆腐、りんご、えのき"}
    end

    if feeling == 3 || sleep_level >= 3
      return { 
        type: "血虚", 
        message: "心がソワソワして、落ち着かないかもしれません。温かいカップを両手で包んで、その温もりを感じながら、ホッと一息つく時間を大切にしてくださいね。",
        foods: "かつお、赤身肉、ひじき、プルーン、卵"}
    end

    # ---------------------------------------------------------
    # 数値良好
    # ---------------------------------------------------------
    { type: "巡り良好",
      message: "心身のバランスが整っています。この心地よいリズムを大切に、今日もあなたのペースで素敵な一日を過ごしてくださいね。",
      foods: "今の調子をキープしましょう！"  
    }
  end

  private

  def once_per_day
    if user.health_records.where(created_at: Time.zone.now.all_day).exists?
      errors.add(:base, "今日の記録はすでに保存されています")
      errors.delete(:feeling) if errors.has_key?(:feeling)
    end
  end
end
