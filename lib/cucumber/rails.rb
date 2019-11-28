# frozen_string_literal: true

called_from_env_rb = caller.detect { |f| f =~ /\/env\.rb:/ }

if called_from_env_rb
  env_caller = File.dirname(called_from_env_rb)

  require 'rails'
  require 'cucumber/rails/application'
  ENV['RAILS_ENV'] ||= 'test'
  ENV['RAILS_ROOT'] ||= File.expand_path(env_caller + '/../..')
  require File.expand_path(ENV['RAILS_ROOT'] + '/config/environment')
  require 'cucumber/rails/action_controller'
  require 'rails/test_help'

  unless Rails.application.config.cache_classes
    warn "WARNING: You have set Rails' config.cache_classes to false
    (most likely in config/environments/cucumber.rb). This setting is known to cause problems
    with database transactions. Set config.cache_classes to true if you want to use transactions."
  end

  require 'cucumber/rails/world'
  require 'cucumber/rails/hooks'
  require 'cucumber/rails/capybara'
  require 'cucumber/rails/database'

  MultiTest.disable_autorun
else
  warn "WARNING: Cucumber-rails required outside of env.rb.  The rest of loading is being deferred
  until env.rb is called. To avoid this warning, move 'gem \'cucumber-rails\', require: false'
  under only group :test in your Gemfile. If already in the :test group, be sure you are
  specifying 'require: false'."
end
