MicroWebsite::Application.routes.draw do
   devise_for :users do
    get "change", :to => "devise/registrations#edit"
    get "/signin", :to => "devise/sessions#new"
    get "signup", :to => "devise/registrations#new"
    get "signout", :to => "devise/sessions#destroy"
  end

 get "user/manage/:type",:to  =>"users#index"
    get "user/disable/:uid", :to=>"users#disable"
    get "user/delete/:uid", :to=>"users#delete"

  # Sample resource route with options:
     resources :sites do
       resources :pages do
         collection do
           post :preview
           get :sub, :form
         end
         member do

         end
       end
     end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'sites#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
