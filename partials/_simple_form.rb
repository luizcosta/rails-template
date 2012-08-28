if would_you_like? "Use simple_form? [y,n]".red
  gsub_file 'Gemfile', /#gem 'simple_form/, "gem 'simple_form"


  after_bundler do
    if would_you_like? "Use simple_form with bootstrap? [y,n]".red
      generate 'simple_form:install --bootstrap'
    else
      generate 'simple_form:install'
    end
    git :add => '.'
    git :commit => "-aqm 'Configure Simple Form.'"
  end
end

