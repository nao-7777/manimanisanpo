Rails.application.routes.draw do
  # 1. ルートパスをTopコントローラーのindexアクションに設定
  root 'top#index'

  # 2. デバイスの設定
  devise_for :users

  # 3. その他の設定（これらはそのままでOK）
  get 'top/index'
  resources :users

  # ...以下略
end
