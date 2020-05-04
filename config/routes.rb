# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, except: :edit do
    resources :answers, shallow: true, only: %i[create destroy update] do
      patch :best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :awards, only: %i[index destroy]
end
