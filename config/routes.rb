Rails.application.routes.draw do
  root 'top#index'

  # 2. マイページ関連
  get 'mypage', to: 'mypage#show', as: 'mypage'
  get 'mypage/edit_name', to: 'mypage#edit_name', as: 'edit_mypage_name'
  get 'mypage/edit_email', to: 'mypage#edit_email', as: 'edit_mypage_email'
  patch 'mypage/update_name', to: 'mypage#update_name', as: 'update_mypage_name'
  patch 'mypage/update_email', to: 'mypage#update_email', as: 'update_mypage_email'

  # 3. デバイスの設定
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users, only: %i[index show edit update]

  get 'welcome', to: 'stories#introduction', as: 'introduction'
  patch 'stories/finish', to: 'stories#finish', as: 'finish_story'
  get 'signup_success', to: 'pages#signup_success'
  get 'password_reset_success', to: 'pages#password_reset_success'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # 5. お散歩・アルバム関連
  resources :walkings, only: %i[index new create show update] do
    collection do
      get :random_mission
      get :evolve
    end

    member do
      patch :save_progress
      post :upload_image
      patch :complete_mission
    end
  end

  get 'album', to: 'walkings#index', as: 'album'

  resources :walking_logs, only: %i[index show] do
    collection do
      get 'date/:date', to: 'walking_logs#date_index', as: :date
    end
  end

  # 6. キャラクター関連
  resources :characters, only: %i[index show] do
    member do
      post :confirm_evolution
    end
  end
  
  # 7. 利用規約・プライバシーポリシー
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'
end
