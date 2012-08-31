puts "Adding devise and omniauth".magenta
gsub_file 'Gemfile', /#gem "devise/, "gem \"devise"
gsub_file 'Gemfile', /#gem "omniauth/, "gem \"omniauth"
gsub_file 'Gemfile', /#gem "omniauth-facebook/, "gem \"omniauth-facebook"
gsub_file 'Gemfile', /#gem "omniauth-twitter/, "gem \"omniauth-twitter"

after_bundler do
  generate 'devise:install'
  configs = <<CONFIGS

  config.omniauth :facebook, 'APP_ID', 'APP_SECRET'
  config.omniauth :twitter, 'APP_ID', 'APP_SECRET'
CONFIGS

  route "devise_for :users"

  in_root do
    inject_into_file 'config/initializers/devise.rb', configs, {before: "\nend", verbose: false}
  end
  git :add => '.'
  git :commit => "-aqm 'Configured the Devise and Omniauth.'"

  copy_static_file 'app/models/user.rb'
  copy_static_file 'app/models/authorization.rb'

  copy_static_file 'db/migrate/devise_create_users.rb', "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_devise_create_users.rb"
  copy_static_file 'db/migrate/create_authorizations.rb', "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S").to_i+1}_create_authorizations.rb"

  copy_static_file 'spec/models/user_spec.rb'
  copy_static_file 'spec/models/authorization_spec.rb'
  copy_static_file 'spec/support/blueprints.rb'

  git :add => '.'
  git :commit => "-aqm 'Create User and Authorization models.'"

  copy_static_file 'app/controllers/users/omniauth_callbacks_controller.rb'
  copy_static_file 'app/controllers/authorizations_controller.rb'

  routes = <<ROUTES

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :authorizations, only: [:destroy]
ROUTES

  in_root do
    inject_into_file 'config/routes.rb', routes, {after: "RailsTemplateTest::Application.routes.draw do", verbose: false}
  end
  git :add => '.'
  git :commit => "-aqm 'Create Users::OmniauthCallbacks and Authorizations controller'"

  run "mkdir app/views/devise/"
  run "cp -rf #{@static_files}/app/views/devise/ app/views/devise/"
  git :add => '.'
  git :commit => "-aqm 'Create Devise views'"

  in_root do
    run "rake db:migrate"
  end
end

