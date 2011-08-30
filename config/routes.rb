WizardRails2::Application.routes.draw do
  root :to => "home#index"
  get 'nouveaux_questionnaire' => 'user_requests#new_request', :as => 'new_request'
  get 'questionnaire/etape_1' => 'user_requests#first_step', :as => 'form_first_step'
  get 'questionnaire/etape_2' => 'user_requests#second_step', :as => 'form_second_step'
  get 'questionnaire/etape_3' => 'user_requests#third_step', :as => 'form_third_step'
  post 'questionnaire/etape_1' => 'user_requests#choose_usages', :as => 'choose_usages'
  post 'questionnaire/etape_2' => 'user_requests#choose_weights', :as => 'choose_weights'
end
