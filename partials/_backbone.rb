puts "Adding the Backbone.js and Underscore.js... ".magenta

run "mkdir app/assets/javascripts/lib"
run "mkdir app/assets/javascripts/app"
run "echo '' > app/assets/javascripts/app/.gitkeep"
run "curl http://documentcloud.github.com/underscore/underscore.js > app/assets/javascripts/lib/underscore.js"
run "curl http://backbonejs.org/backbone.js > app/assets/javascripts/lib/backbone.js"

git :add => '.'
git :commit => "-qm 'Add backbone.js and underscore.js'"
