Spree::Core::Engine.routes.prepend do
  resources :addresses, :except => :show
end
