Rails.application.routes.draw do
  resource  :sessions,  only: %i[create destroy]
  resources :customers, only: %i[index show create update destroy]
end
