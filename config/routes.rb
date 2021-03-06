Rails.application.routes.draw do
  resources :projects

  get 'index' => 'index#index'

  get 'index/fav_list'

  get 'admin' => 'admin#index'

  get 'admin/index'

  get 'admin/projects' => 'admin#list', as: 'admin_list'

  get 'admin/projects/:id' => 'admin#detail', as: 'detail_admin'

  get 'admin/entries'

  get 'admin/reqest'

  get 'admin/entries/:id' => 'admin#approval', as: 'approval'

  get 'admin/projects/:id/edit' => 'admin#edit', as: 'edit'

  get 'admin/word_list' => 'admin#word_list'

  get 'fav' => 'projects#fav'

  get '/' => 'index#index'

  get 'setup' => 'projects#setup'

  post 'fav_remove' => 'projects#fav_remove'

  post 'fav_remove' => 'index#fav_remove'

  post 'fav' => 'projects#fav'

  post 'confirm' => 'admin#confirm'

  post 'reject' => 'admin#reject'

  post 'destroy' => 'admin#destroy'

  post 'make' => 'admin#make'

  post 'kind' => 'projects#kind'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
