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
def copy_static_file(path)
  # puts "Installing #{path}...".magenta
  remove_file path
  file path, File.read(File.join(@static_files, path))
  # puts "\n"
end

def apply_n(partial)
  apply "#{@partials}/_#{partial}.rb"
end

puts "\n========================================================="
puts " STARTUPDEV RAILS 3 TEMPLATE".yellow.bold
puts "=========================================================\n"

# TODO: timezone, Add rspec extensions

apply_n :git
apply_n :cleanup
apply_n :database
apply_n :rspec
apply_n :default
apply_n :backbone
apply_n :javascripts
apply_n :generators
apply_n :gems
apply_n :rvm
#apply_n :heroku

# apply_n :omniauth # TODO: add spec support files
                    # TODO: take care of facebook when user is not logged in on facebook (when app)
# TODO: extrair phone validator to gem

run 'bundle install'
puts "\nRunning after Bundler callbacks."
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

@current_recipe = nil
puts "\nRunning after everything callbacks."
@after_everything_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; b[1].call}

puts "\n========================================================="
puts " INSTALLATION COMPLETE!".yellow.bold
puts "=========================================================\n\n\n"
