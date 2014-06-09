Coursewareofthefuture::Application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: :omniauth_callbacks }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :courses, except: [:edit, :update, :destroy] do
    resources :assignments, except: [:edit, :update, :destroy] do
      get :select, on: :collection
    end
    get :calendar, to: 'events#index'
    resources :enrollments, only: [:index, :create]
    resources :events, only: [:new, :create]
    resources :materials, only: [:index, :show], constraints: { id: /.*/ }
    resources :covered_materials, only: [:create, :update] do
      member do
        get :slides
        get '/:asset_file', to: "covered_materials#asset"
      end
    end
    resources :quizzes, except: [:index, :show, :destroy] do
      member do
        get :grade
      end
      resource :quiz_submission, except: [:destroy], as: :submission, path: :s
    end
  end
  resource :enrollment, only: [:new]
  resources :milestone_submissions, only: [:create]
  resources :question_grades, only: [:edit, :update]
  resources :self_reports, except: [:destroy]
  resources :users, except: [:destroy] do
    member do
      post :instructify
    end
  end
  resource :instructor, only: [] do
    member do
      post :destudentify
      post :studentify
    end
  end
  get '/theme/css/:filename', to: redirect{ |params, req| "/assets/theme/#{params[:filename]}.#{params[:format]}" }
  get '/js/*filename', to: redirect{ |params, req| "/assets/theme/#{params[:filename]}.#{params[:format]}" }
end
