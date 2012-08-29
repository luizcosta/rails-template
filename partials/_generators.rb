puts "Configuring the Rails Generators... ".magenta

generators = <<GENERATORS

    # Do not generate specs for views and requests. Also, do not generate assets.
    config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.template_engine :slim
      g.test_framework :rspec,
        :view_specs => false,
        :helper_specs => false
    end

    # Prevent initializing your application and connect to the database on assets precompile.
    config.assets.initialize_on_precompile = false
GENERATORS
in_root do
  inject_into_file 'config/application.rb', generators, {after: "Rails::Application", verbose: false}
end
git :add => 'config/application.rb'
git :commit => "-qm 'Adding configurations for generators.'"
