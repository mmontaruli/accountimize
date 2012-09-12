require 'subdomain'

Accountimize::Application.routes.draw do

  # get "messages/index"

  # get "messages/show"

  # get "messages/destroy"

  resources :messages

  #get "password_resets/new"
  resources :password_resets

  resources :invoices do
    #member do
    collection do
      get 'generateInvoiceFromMilestone'
    end
  end

  resources :users
  resources :sessions

  get "sign_up" => "accounts#new", :as => "sign_up"

  resources :accounts

  resources :clients do
    get :client_address, on: :member
  end

  resources :estimates do
    #resources :invoice_schedules, :shallow => true
    resource :invoice_schedule, :shallow => true
  end

  constraints(Subdomain) do
    match '/' => 'accounts#show'
    get "log_in" => "sessions#new", :as => "log_in"
    get "log_out" => "sessions#destroy", :as => "log_out"
    get "register" => "users#new", :as => "register"
  end
  root :to => 'site#index', :as => 'site'
end
