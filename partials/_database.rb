copy_static_file 'config/database.yml.sample'
gsub_file 'config/database.yml.sample', /PROJECT/, @app_name
git :add => 'config/database.yml.sample'
git :commit => "-qm 'Adding config/database.yml.sample.'"

puts "\n"
