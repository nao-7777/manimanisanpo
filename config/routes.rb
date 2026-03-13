Rails.application.routes.draw do
  # 1. ルートパスをTopコントローラーのindexアクションに設定
  root 'top#index'

  # 2. デバイスの設定
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # 3. その他の設定（これらはそのままでOK）
  get 'top/index'
  resources :users

  # 4. 完了ページを表示するためのURL
  get 'signup_success', to: 'pages#signup_success'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get 'password_reset_success', to: 'pages#password_reset_success'
end
