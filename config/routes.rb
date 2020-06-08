# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :voteable do
    defaults format: :json do
      member do
        post :vote_up
        post :vote_down
        delete :vote_cancel
      end
    end
  end

  root to: 'questions#index'

  resources :questions, except: :edit do
    resources :answers, shallow: true, only: %i[create destroy update] do
      patch :best, on: :member

      concerns :voteable
    end

    concerns :voteable
  end

  resources :files, only: :destroy
  resources :awards, only: %i[index destroy]
end
