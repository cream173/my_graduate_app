class HealthRecord < ApplicationRecord
  belongs_to :user
  has_many :health_record_symptoms, dependent: :destroy
  has_many :symptoms, through: :health_record_symptoms

  validates :feeling, presence: true
  validates :fatigue_level, presence: true
  validates :stress_level, presence: true

  def kampo_advice(manual_symptoms = nil)

    # 選択された症状の名前を配列で取得
    s_names = manual_symptoms || symptoms.pluck(:name)

    # ---------------------------------------------------------
    # 1. 気分 × 体調 の掛け合わせパターン
    # ---------------------------------------------------------

    # --- イライラ・ストレス系 (気滞・気逆ベース) ---
    if feeling == 5 || stress_level >= 4
      if s_names.intersect?(["頭痛", "のぼせ"])
        return { type: "気逆（きぎゃく）", message: "ストレスで気が頭にのぼり、パンパンに張っています。ミントの香りを嗅いだり、足元を温めて気を下に降ろしましょう。" }
      elsif s_names.intersect?(["胃のむかつき", "便秘"])
        return { type: "気滞（きたい）", message: "気が滞り、胃腸の動きを邪魔しています。シトラス系の香りで巡りを整え、詰まった気を外へ逃がしてあげて。" }
      elsif s_names.include?("肩こり")
        return { type: "気滞 + 瘀血", message: "緊張で血の流れがギュッと止まっています。深呼吸をして肩の力を抜き、まずは心を緩める時間を作ってください。" }
      end
    end

    # --- 不安・眠れない系 (血虚ベース) ---
    if feeling == 3 || sleep_level >= 4
      if s_names.intersect?(["目の疲れ", "めまい"])
        return { type: "血虚（けっきょ）", message: "心を潤す「血」が不足し、目や頭まで栄養が届いていません。スマホを置いて目を閉じ、なつめやクコの実で栄養を補いましょう。" }
      elsif s_names.intersect?(["乾燥", "便秘"])
        return { type: "血虚 + 津液不足", message: "体も心も乾ききっている状態です。白い食材（豆腐や白ごま）を摂り、内側から潤いを与えて心を落ち着かせましょう。" }
      elsif s_names.intersect?(["冷え", "肩こり"])
        return { type: "血虚 + 瘀血", message: "血が薄く、全身を温める力が足りません。足湯をしたり、赤い食材を食べて、ゆっくりと巡りを高めていきましょう。" }
      end
    end

    # --- しんどい・無気力系 (気虚ベース) ---
    if feeling == 4 || fatigue_level >= 4
      if s_names.intersect?(["食欲不振", "お腹がゆるい", "胃のむかつき"])
        return { type: "脾気虚（ひききょ）", message: "胃腸のエネルギーが落ち、栄養を作れなくなっています。温かいお粥や生姜を摂り、お腹の芯から温めて元気を蓄えて。" }
      elsif s_names.intersect?(["むくみ", "体が重い"])
        return { type: "気虚 + 水滞", message: "エネルギー不足で、体内の水分を動かす力がありません。小豆茶などで余分な水を出し、自分を一番に労わって休ませてあげて。" }
      elsif s_names.intersect?(["めまい", "頭痛"])
        return { type: "気虚 + 巡り不足", message: "脳までパワーが届かず、フラフラしやすい状態です。深くゆっくり呼吸をして、新しい気を取り込み、一歩ずつ進んでいきましょう。" }
      end
    end

    # ---------------------------------------------------------
    # 症状のみのパターン
    # ---------------------------------------------------------

    # 水滞（すいたい）
    if s_names.intersect?(["むくみ", "体が重い", "頭痛", "お腹がゆるい"])
      return { type: "水滞（すいたい）", message: "余分な水分が溜まり、体が重だるくなっています。冷たいものを控え、巡りを助けるハトムギなどを取り入れてみて。" }
    end

    # 瘀血（おけつ）
    if s_names.intersect?(["肩こり", "冷え", "便秘", "頭痛"])
      return { type: "瘀血（おけつ）", message: "血の巡りが滞り、コリや痛みとして現れています。湯船にゆっくり浸かって、川の流れをスムーズにするイメージでリラックスを。" }
    end

    # ---------------------------------------------------------
    # 必須項目の数値のみのパターン
    # ---------------------------------------------------------

    return { type: "気滞", message: "少し気がたかぶっています。好きな音楽を聴いてリラックスしましょう。" } if feeling == 5 || stress_level >= 3
    return { type: "気虚", message: "エネルギーが減っています。今日は早めに布団に入りましょう。" } if feeling == 4 || fatigue_level >= 3
    return { type: "血虚", message: "心がソワソワしています。温かい飲み物で自分を癒やして。" } if feeling == 3 || sleep_level >= 3

    # ---------------------------------------------------------
    # 良好
    # ---------------------------------------------------------
    { type: "巡り良好", message: "心身のバランスが整っています。この心地よいリズムを大切に、今日もあなたのペースで素敵な一日を。" }
  end
end
