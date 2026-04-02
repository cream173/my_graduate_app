# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

symptoms = ["頭痛", "肩こり", "めまい", "目の疲れ", "冷え", "のぼせ", "むくみ",
            "乾燥", "便秘", "食欲不振", "体が重い", "胃のむかつき", "お腹がゆるい"] 
symptoms.each do |name|
  Symptom.find_or_create_by!(name: name)
end
