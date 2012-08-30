puts "Configuring/Creating the Heroku... ".magenta

if would_you_like? "Configure/Create Heroku app? [y,n]".red
  say "Configuring Heroku application...".magenta
  heroku_name = @app_name.gsub('_','')

  config = {}

  config['staging'] = would_you_like? "Create staging app? (#{heroku_name}-staging.heroku.com) [y,n]".red
  config['deploy']  = would_you_like? "Deploy immediately? [y,n]".red
  config['domain']  = ask "Add custom domain(customdomain.com) or leave blank".red

  accounts_unsupported = run "heroku accounts | grep 'is not a heroku command'"

  account_cmd = ""
  unless accounts_unsupported
    heroku_account = ask "Which Heroku account?".red
    account_cmd = "--account #{heroku_account}"
  end

  run "heroku login" if accounts_unsupported

  say "Creating Heroku app '#{heroku_name}.heroku.com'".magenta
  while !system("heroku create #{heroku_name} #{account_cmd}")
    heroku_name = ask "What do you want to call your app? ".red
  end

  if config['staging']
    staging_name = "#{heroku_name}-staging"
    say "Creating staging Heroku app '#{staging_name}.herokuapp.com'".magenta
    while !system("heroku create #{staging_name} #{account_cmd}")
      staging_name = ask "What do you want to call your staging app?".red
    end
    git :remote => "add heroku git@heroku.com:#{heroku_name}.git"
    say "Add git remote heroku for Heroku deploy.".magenta
  end


  unless config['domain'].blank?
    run "heroku domains:add #{config['domain']} #{account_cmd}"
  end

  #colaborators = ask "Add collaborators? Type the email's separated by comma.".red

  #colaborators.split(",").map(&:strip).each do |email|
    #run "heroku sharing:add #{email} #{account_cmd}"
  #end

  say "Adding heroku addon [PG Backups]...".magenta
  run "heroku addons:add pgbackups:plus #{account_cmd}"

  say "Adding heroku addon [Loggly]...".magenta
  run "heroku addons:add loggly:mole #{account_cmd}"

  sendgrid = ask "Add sendgrid:starter addon?".red

  if sendgrid
    say "Adding heroku addon [Sendgrid]...".magenta
    run "heroku addons:add sendgrid:starter #{account_cmd}"
  end

  if config['deploy']
    say "Pushing application to heroku...".magenta
    git :push => "heroku master"
  end
end
