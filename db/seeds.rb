Mission.destroy_all

# 写真が必要なミッション (requires_photo: true)
photo_missions = [
  "赤いポストを撮ろう",
  "自動販売機のボタンを撮ろう",
  "カーブミラーの中の自分を撮ろう",
  "マンホールの蓋を撮ろう",
  "黄色い看板を撮ろう",
  "「止まれ」の標識を撮ろう",
  "季節の花を撮ろう",
  "公園のベンチを撮ろう",
  "面白い形の雲を撮ろう",
  "自転車の車輪を撮ろう"
].map { |t| { title: t, requires_photo: true } }

# 写真不要 行動・発見ミッション (requires_photo: false)
action_missions = [
  "一番近くの「橋」を渡り切ろう", 
  "大きな通りに出るまで、<br>ひたすら真っ直ぐ歩こう", 
  "公園にたどり着くまで歩こう",
  "今から5分間、<br>一度も曲がらずに歩き続けてみよう",
  "「郵便局」か「コンビニ」を<br>見つけるまで歩いてみよう",
  "一番近い「信号機」がある<br>交差点まで行ってみよう",
  "どこかの「ベンチ」を見つけて、<br>3分間座って休憩しよう",
  "川や線路沿いなど、<br>見晴らしの良い場所まで歩こう",
  "今まで通ったことのない<br>「細い道」を選んで進んでみよう",
  "10分間、風を感じながら歩こう<br>（タイマー開始！）"
].map { |t| { title: t, requires_photo: false } }

# データベースに登録
(photo_missions + action_missions).each do |m|
  Mission.create!(m)
end

puts "✅ 合計 #{Mission.count} 個のミッションを登録しました！"

# キャラクターデータの登録
Character.destroy_all

# 金宵（こよい）くんの登録
Character.create!(
  name: "金宵 (こよい)",
  description: "夜の静寂を好む、非常に知恵の回る子狐。主の歩みに合わせて無邪気に跳ねているように見えるが、実はその歩幅やリズムを微妙に狂わせて楽しむといった、いたずら好きな一面がある。物事の真理を悟ったような高い知性を備えているが、退屈を何よりも嫌う性分である。",
  description_v2: "幾千の夜を越え、本来の威厳ある姿を取り戻した妖狐。その瞳には過去と未来のすべてが映ると伝承されている。姿は雅に変化したが、主をからかって反応を見ることを好むお茶目な気質は変わっていない。主がミッションに奔走する姿を、扇で口元を隠しながら密かに観察している。",
  image_v1: "characters/金宵_v1.png", # 💡 app/assets/images/characters/ に入れるファイル名
  image_v2: "characters/金宵_v2.png", # 💡 進化後のファイル名
  rarity: 5,
  evolution_level: 10        # 💡 前回のロジックに合わせて「10」に設定
)

# 開発用：自分自身に最初から金宵くんを付与しておく（テスト用）
UserCharacter.destroy_all
user = User.first # 最初のユーザーを取得
if user
  kinyo = Character.find_by(name: "金宵 (こよい)")
  UserCharacter.create!(
    user: user, 
    character: koyoi, 
    evolved: false
  )
end

puts "✅ ミッションとキャラクター（金宵）を登録しました！"