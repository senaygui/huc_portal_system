Rails.application.routes.draw do
  
  resources :grade_reports
  # devise_for :students
  
  devise_for :students, controllers: {
    registrations: 'registrations'
  }
  authenticated :student do
    root 'pages#dashboard', as: 'authenticated_user_root'
  end
  get 'admission' => 'pages#admission'
  get 'documents' => 'pages#documents'
  get 'profile' => 'pages#profile'
  get 'grade_report' => 'pages#grade_report'
  get 'digital-iteracy-quiz' => 'pages#digital_iteracy_quiz'
  get 'requirements' => 'pages#requirement'
  get 'home' => 'pages#home'
  resources :almunis
  resources :semester_registrations
  resources :invoices
  resources :payment_methods
  resources :payment_transactions
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: 'application#home'
end
