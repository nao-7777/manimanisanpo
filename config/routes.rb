Rails.application.routes.draw do
  # 1. ルートパス
  root 'top#index'

  # 2. マイページ関連（ここを上に持ってくるのが一番安全）
  get 'mypage',            to: 'mypage#show',       as: 'mypage'
  get 'mypage/edit_name',  to: 'mypage#edit_name',  as: 'edit_mypage_name'
  get 'mypage/edit_email', to: 'mypage#edit_email', as: 'edit_mypage_email'
  patch 'mypage/update_name', to: 'mypage#update_name', as: 'update_mypage_name'
  patch 'mypage/update_email', to: 'mypage#update_email', as: 'update_mypage_email'
  resources :walkings, only: [:new, :create]

  # 3. デバイスの設定（ログアウトを確実に優先させる）
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # 4. その他ユーザー関連（ログアウトと被らないように制限をかける）
  # 💡 only: [...] を指定して、ログアウト(DELETE)と被る destroy などを除外する
  resources :users, only: [:index, :show, :edit, :update] 

  # --- 以下、ストーリー関連など ---
  get 'welcome', to: 'stories#introduction', as: 'introduction'
  patch 'stories/finish', to: 'stories#finish', as: 'finish_story'
  
  get 'signup_success', to: 'pages#signup_success'
  get 'password_reset_success', to: 'pages#password_reset_success'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
