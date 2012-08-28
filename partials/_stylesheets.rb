say "Configuring stylesheets...".magenta

run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.sass'

git :add => '.'
git :rm => 'app/assets/stylesheets/application.css'
git :commit => "-aqm 'Renamed application.css to application.sass'"

if would_you_like? "Use twitter bootstrap? [y,n]".red
  gsub_file 'Gemfile', /#gem 'bootstrap-sass/, "gem 'bootstrap-sass"
end
run "echo '\n@import bootstrap' >> app/assets/stylesheets/application.sass"

git :add => '.'
git :commit => "-aqm 'Add twitter bootstrap'"

