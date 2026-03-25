Rails.application.routes.draw do
  # 1. ルートパス
  root 'top#index'

  # 2. マイページ関連
  get 'mypage',             to: 'mypage#show',         as: 'mypage'
  get 'mypage/edit_name',   to: 'mypage#edit_name',    as: 'edit_mypage_name'
  get 'mypage/edit_email',  to: 'mypage#edit_email',   as: 'edit_mypage_email'
  patch 'mypage/update_name', to: 'mypage#update_name', as: 'update_mypage_name'
  patch 'mypage/update_email', to: 'mypage#update_email', as: 'update_mypage_email'

  # 3. デバイスの設定
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # 4. その他ユーザー関連
  resources :users, only: [:index, :show, :edit, :update] 

  # --- ストーリー・その他 ---
  get 'welcome', to: 'stories#introduction', as: 'introduction'
  patch 'stories/finish', to: 'stories#finish', as: 'finish_story'
  get 'signup_success', to: 'pages#signup_success'
  get 'password_reset_success', to: 'pages#password_reset_success'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # 5. お散歩・アルバム関連（ここを1つに統合）
  resources :walkings, only: [:index, :new, :create, :show, :update] do
    member do
      # 💡 途中保存用のルーティングを追加
      patch :save_progress 
    end
    collection do
      get :random_mission
      post :upload_image
    end
  end

  # アルバムへのショートカット
  get 'album', to: 'walkings#index', as: 'album'

  # 💡 WalksControllerは不要になったので resources :walks は削除しました
end
