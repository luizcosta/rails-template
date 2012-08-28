puts "Adding default files ...".magenta

copy_static_file 'app/views/layouts/application.html.slim'
gsub_file 'app/views/layouts/application.html.slim', /PROJECT/, @app_name
git :add => '.'
git :commit => "-aqm 'Add application layout in slim.'"

copy_static_file 'config/locales/rails.pt-BR.yml'
git :add => '.'
git :commit => "-aqm 'Add rails locale for pt-BR.'"

copy_static_file '.gitignore'

git :add => '.'
git :commit => "-aqm 'Add default stuff.'"
puts "\n"
