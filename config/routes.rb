require 'subdomain'

Accountimize::Application.routes.draw do

  resources :invoices do
    member do
      get 'generateInvoiceFromMilestone'
    end
  end

  #get "log_in" => "sessions#new", :as => "log_in"
  #get "log_out" => "sessions#destroy", :as => "log_out"

  #get "sign_up" => "users#new", :as => "sign_up"
  resources :users
  resources :sessions

  get "sign_up" => "accounts#new", :as => "sign_up"

  #resources :accounts do
    #resources :clients do
    #  get :client_address, on: :member
    #end
    #resources :estimates do
    #  resources :invoice_schedules
    #end
    #resources :invoices do
    #  member do
    #    get 'generateInvoiceFromMilestone'
    #  end
    #end
  #end

  resources :accounts

  resources :clients do
    get :client_address, on: :member
  end

  resources :estimates do
    resources :invoice_schedules
  end

  #get "site/index"

  resources :line_items

  constraints(Subdomain) do
    match '/' => 'accounts#show'
    get "log_in" => "sessions#new", :as => "log_in"
    get "log_out" => "sessions#destroy", :as => "log_out"
    get "register" => "users#new", :as => "register"
  end
  root :to => 'site#index', :as => 'site'
end
