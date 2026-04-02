class CharactersController < ApplicationController
  before_action :authenticate_user!
  def index
    # 全キャラクターを取得
    @all_characters = Character.all
    # ユーザーが持っているキャラクターのIDを配列で取得（持っているかどうかの判定用）
    @user_character_ids = current_user.user_characters.pluck(:character_id)
  end

  def show
    @character = Character.find(params[:id])
    @user_character = current_user.user_characters.find_by(character: @character)
    
    # まだ持っていないキャラの詳細を見ようとしたら一覧に戻す（ガード処理）
    redirect_to characters_path, alert: "まだ出会っていないキャラクターです" unless @user_character
  end

  def confirm_evolution
    @user_char = current_user.user_characters.find(params[:id])
    @user_char.update!(evolved: true)
    
    redirect_to root_path
  end
end