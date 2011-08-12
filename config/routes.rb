WizardRails2::Application.routes.draw do
  root :to => "home#index"

  resources :user_requests, :only => [:new]
end
