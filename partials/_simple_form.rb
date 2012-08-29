if would_you_like? "Do you want use the simple_form? [y,n]".red
  gsub_file 'Gemfile', /#gem 'simple_form/, "gem 'simple_form"


  after_bundler do
    if would_you_like? "Do you want use the simple_form with twitter bootstrap? [y,n]".red
      generate 'simple_form:install --bootstrap'
    else
      generate 'simple_form:install'
    end
    git :add => '.'
    git :commit => "-aqm 'Configure simple_form.'"
  end
end

