# 1. ミッションデータの登録（重複させない）
photo_missions = [
  "赤いポストを撮ろう", "自動販売機のボタンを撮ろう", "カーブミラーの中の自分を撮ろう",
  "マンホールの蓋を撮ろう", "黄色い看板を撮ろう", "「止まれ」の標識を撮ろう",
  "季節の花を撮ろう", "公園のベンチを撮ろう", "面白い形の雲を撮ろう", "自転車の車輪を撮ろう"
].map { |t| { title: t, requires_photo: true } }

action_missions = [
  "一番近くの「橋」を渡り切ろう", 
  "大きな通りに出るまで、<br>ひたすら真っ真直ぐ歩こう", 
  "公園にたどり着くまで歩こう",
  "今から5分間、<br>一度も曲がらずに歩き続けてみよう",
  "「郵便局」か「コンビニ」を<br>見つけるまで歩いてみよう",
  "一番近い「信号機」がある<br>交差点まで行ってみよう",
  "どこかの「ベンチ」を見つけて、<br>3分間座って休憩しよう",
  "川や線路沿いなど、<br>見晴らしの良い場所まで歩こう",
  "今まで通ったことのない<br>「細い道」を選んで進んでみよう",
  "10分間、風を感じながら歩こう<br>（タイマー開始！）"
].map { |t| { title: t, requires_photo: false } }

(photo_missions + action_missions).each do |m|
  # titleをキーにして、存在しなければ作成、あれば更新する
  mission = Mission.find_or_initialize_by(title: m[:title])
  mission.requires_photo = m[:requires_photo]
  mission.save!
end

puts "✅ ミッションを #{Mission.count} 個登録・更新しました。"

# 2. キャラクター「金宵（こよい）」の登録・更新（ここは今のままで完璧！）
koyoi = Character.find_or_create_by!(name: "金宵 (こよい)")

koyoi.update!(
  description: "夜の静寂を好む、非常に知恵の回る子狐。...",
  description_v2: "幾千の夜を越え、本来の威厳ある姿を取り戻した妖狐。...",
  image_v1: "characters/koyoi_v1.png",
  image_v2: "characters/koyoi_v2.png",
  rarity: 5,
  evolution_level: 10
)
puts "✅ キャラクター「金宵」のデータを更新しました。"

# 3. ユーザーへの付与（安全策）
user = User.first
if user
  UserCharacter.find_or_create_by!(user: user, character: koyoi) do |uc|
    uc.evolved = false
  end
end
puts "✅ 既存の育成データを保護したまま、シードの実行が完了しました！"