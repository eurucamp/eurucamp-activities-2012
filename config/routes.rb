EurucampActivities::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  post "notifications" => "notifications#create"

  root :to => "participations#index"
end
