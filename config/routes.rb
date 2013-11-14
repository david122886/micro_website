MicroWebsite::Application.routes.draw do
  devise_for :users do
    get "change", :to => "devise/registrations#edit"
    get "change_password", :to => "devise/passwords#edit"
    get "signin", :to => "devise/sessions#new"
    get "signup", :to => "devise/registrations#new"
    get "signout", :to => "devise/sessions#destroy"
  end

		get "user/manage/:type", :to=>"users#index"   
    post "user/disable/:uid", :to=>"users#disable"
   	post "user/enable/:uid", :to=>"users#enable"       
    get "user/delete/:uid", :to=>"users#delete"
  match '/destroy_site' ,:to=>'sites#destroy_site' ,via: 'get'
  match "/sites/:site_id/pages/preview", :to => "pages#preview", :as => "preview"
  match '/check_zip' ,to: 'resources#is_not_repeat' ,via: 'get'
  # Sample resource route with options:
  resources :sites do
    resources :resources
    resources :pages do
      collection do
        get :sub, :form, :style, :sub_new,  :form_new
        post :preview
      end
      member do
        get :sub_edit,:form_edit, :if_authenticate, :sub_preview
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

