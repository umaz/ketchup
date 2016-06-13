Rails.application.routes.draw do
  resources :projects

  get 'index' => 'index#index'

  get 'index/fav_list'

  get 'index/fav_delete'

#  get 'admin' => 'admin#index'

  get 'admin/index'

  get 'admin/list'

  get 'admin/detail/:id' => 'admin#detail', as: 'detail_admin'

  get 'admin/entry'

  get 'admin/reqest'

  get 'admin/entry/:id' => 'admin#approval', as: 'admin'

  get 'admin/detail/:id/edit' => 'admin#edit', as: 'edit'

  get '/' => 'index#index'

  get 'projects/search'

  get 'projects/detail/:id' => 'projects#detail', as: 'detail'

  get 'projects/fav_list'

  get 'projects/fav_delete'

  post 'projects' => 'projects#create'

  post 'projects/fav' => 'projects#fav'

  post 'fav_remove_in_detail' => 'projects#fav_remove_in_detail'

  post 'fav_remove_in_list' => 'projects#fav_remove_in_list'

  post 'fav_remove_in_fav_list' => 'index#fav_remove_in_fav_list'

  post 'fav_detail' => 'projects#fav_detail'

  post 'fav_all' => 'projects#fav_all'

  post 'confirm' => 'admin#confirm'

  post 'reject' => 'admin#reject'
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
