puts "Setting up RSpec ... ".magenta

remove_dir 'test'

copy_static_file 'spec/support/capybara.rb'

git :add => '.'
git :commit => "-aqm 'Add RSpec support files.'"

after_bundler do
  generate 'rspec:install'
  generate 'machinist:install'
  run 'bundle exec jasmine init '
  run 'rm -f public/javascripts/Player.js public/javascripts/Song.js spec/javascripts/PlayerSpec.js spec/javascripts/helpers/SpecHelper.js lib/tasks/jasmine.rake'
  git :add => '.'
  git :commit => "-aqm 'Configure RSpec.'"
end

puts "\n"

