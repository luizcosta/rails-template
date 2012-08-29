puts "Copying the Gemfile... ".magenta

copy_static_file 'Gemfile'
git :add => 'Gemfile'
git :commit => "-qm 'Adding Gemfile.'"

puts "\n"
