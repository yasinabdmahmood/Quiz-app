Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

   get '/test', to: 'test#hello'

   # Route for user registration (POST /register)
   post '/register', to: 'users#register'

   # Route for user login (POST /login)
   post '/login', to: 'users#login'

end
