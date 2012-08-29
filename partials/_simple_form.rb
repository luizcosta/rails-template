puts "Configuring the simple_form... ".magenta

gsub_file 'Gemfile', /#gem 'simple_form/, "gem 'simple_form"

after_bundler do
  generate 'simple_form:install --bootstrap'
  git :add => '.'
  git :commit => "-aqm 'Configure simple_form.'"
end
