copy_static_file 'app/assets/javascripts/app.js'
copy_static_file 'app/assets/javascripts/init.js'

gsub_file 'app/assets/javascripts/application.js', "//= require_tree .", "
//= require ./lib/underscore.js
//= require ./lib/backbone.js
//= require_tree ./lib
//= require ./app.js
//= require_tree ./app
//= require ./init.js
"
git :add => '.'
git :commit => "-aqm 'Add defaults javascripts'"
