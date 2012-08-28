copy_static_file 'config/database.sample.yml'
gsub_file 'config/database.sample.yml', /PROJECT/, @app_name
run 'cp -f config/database.sample.yml config/database.yml'

git :add => 'config/database.sample.yml'
git :commit => "-qm 'Adding config/database.sample.yml.'"

after_bundler do
  in_root do
    run "rake db:create"
  end
end
puts "\n"
