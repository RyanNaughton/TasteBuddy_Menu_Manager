Menu::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }
  match 'users/bookmarks' => 'user_attributes#bookmarks', :via => :get
  match 'users/profile' => 'user_attributes#profile', :via => :get
  match 'users/attributes' => 'user_attributes#attributes', :via => :get
  match 'users/update' => 'user_attributes#update', :via => :put

  match 'search' => 'search#new', :via => :get
  match 'search' => 'search#show', :via => :post
  match 'complete' => 'autocompletes#new', :via => :get
  match 'complete' => 'autocompletes#show', :via => :post

  resources :pictures do
    member do
      put 'comment'
    end
  end

  resources :menu_items do
    collection do
      get 'export'
    end
    member do
      put 'rate'
      put 'comment'
    end
  end
  match 'menu_items/:id/bookmark' => 'menu_items#add_bookmark', :via => :put
  match 'menu_items/:id/bookmark' => 'menu_items#remove_bookmark', :via => :delete
  match 'menu_items/:id/tag' => 'menu_items#add_tag', :via => :put
  match 'menu_items/:id/tag' => 'menu_items#remove_tag', :via => :delete

  resources :restaurants do
    resources :menu_items
    member do
      put 'rate'
      put 'comment'
    end
  end
  match 'restaurants/:id/bookmark' => 'restaurants#add_bookmark', :via => :put
  match 'restaurants/:id/bookmark' => 'restaurants#remove_bookmark', :via => :delete
  match 'restaurants/:id/tag' => 'restaurants#add_tag', :via => :put
  match 'restaurants/:id/tag' => 'restaurants#remove_tag', :via => :delete

  resources :tags do
    collection do
      get 'subset'
    end
  end

  match 'restaurants/:id/menu_sections/:index' => 'menus#show'
  match 'restaurants/:id/menu' => 'full_menus#show'

  root :to => 'restaurants#index'
end
