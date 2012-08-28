copy_static_file 'config/database.sample.yml'
gsub_file 'config/database.sample.yml', /PROJECT/, @app_name
git :add => 'config/database.sample.yml'
git :commit => "-qm 'Adding config/database.sample.yml.'"

puts "\n"
