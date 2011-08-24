WizardRails2::Application.routes.draw do
  root :to => "home#index"
  get 'questionnaire/etape_1' => 'user_requests#first_step', :as => 'form_first_step'
  get 'questionnaire/etape_2' => 'user_requests#second_step', :as => 'form_second_step'
  post 'questionnaire/etape_1' => 'user_requests#choose_usages', :as => 'choose_usages'
end
