#
# startupdev-rails-template
#
# Usage:
#   rails new appname -m /path/to/template.rb
#
# Also see http://textmate.rubyforge.org/thor/Thor/Actions.html
#

%w{colored}.each do |component|
  if Gem::Specification.find_all_by_name(component).empty?
    run "gem install #{component}"
    Gem.refresh
    Gem::Specification.find_by_name(component).activate
  end
end

require "rails"
require "colored"
require "bundler"

# Directories for template partials and static files
@template_root = File.expand_path(File.join(File.dirname(__FILE__)))
@partials     = File.join(@template_root, 'partials')
@static_files = File.join(@template_root, 'files')

@current_recipe = nil
@configs = {}

@after_blocks = []
def after_bundler(&block); @after_blocks << [@current_recipe, block]; end
@after_everything_blocks = []
def after_everything(&block); @after_everything_blocks << [@current_recipe, block]; end
@before_configs = {}
def before_config(&block); @before_configs[@current_recipe] = block; end

# Copy a static file from the template into the new application
def copy_static_file(path, new_path = false)
  # puts "Installing #{path}...".magenta
  new_path = path unless new_path
  remove_file new_path
  file new_path, File.read(File.join(@static_files, path))
  # puts "\n"
end

def apply_n(partial)
  apply "#{@partials}/_#{partial}.rb"
end

def would_you_like?(question)
  answer = ask("#{question}".red)
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      would_you_like?(question)
  end
end

puts "\n========================================================="
puts " STARTUPDEV RAILS 3 TEMPLATE".yellow.bold
puts "=========================================================\n"

# TODO: timezone, Add rspec extensions

apply_n :git
apply_n :cleanup
apply_n :gems
apply_n :default
apply_n :database
apply_n :rspec
apply_n :backbone
apply_n :javascripts
apply_n :stylesheets
apply_n :generators
apply_n :rvm
apply_n :devise_omniauth
apply_n :simple_form

after_bundler do
  apply_n :heroku
end

run 'bundle install'
puts "\nRunning after Bundler callbacks."
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
puts "\nRunning after everything callbacks."
@after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

puts "\n========================================================="
puts " INSTALLATION COMPLETE!".yellow.bold
puts "=========================================================\n\n\n"
