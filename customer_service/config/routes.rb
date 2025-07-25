Rails.application.routes.draw do
  resources :customers, only: [:index, :show]
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
