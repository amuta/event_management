Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # POST /signup - Register a new user (Returns an authentication token).
  post '/signup', to: 'authentication#signup'
  # POST /login - Authenticate a user and return a token.
  post '/login', to: 'authentication#login'

  # GET /events - List all events.
  # GET /events/:id - Get details of a specific event.
  # PUT /events/:id - Update an event (only for the user who created the event).
  # DELETE /events/:id - Delete an event (only for the user who created the event).
  resources :events, only: %i[index show create update destroy]

  # Admin Routes for viewing and assigning user's roles.
  namespace :admin do
    get '/users', to: 'admin#index_users'
    get '/roles', to: 'admin#index_roles'
    get '/users/:user_id/roles', to: 'admin#index_user_roles'
    post '/users/:user_id/roles/:role_id/add', to: 'admin#add_user_role'
    delete '/users/:user_id/roles/:role_id/remove', to: 'admin#remove_user_role'
  end
end
