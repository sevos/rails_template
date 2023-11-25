# remove gem "turbo-rails" from Gemfile
run "sed -i '/gem \"turbo-rails\"/d' Gemfile"

# Gems
gem 'turbo-rails', github: 'sevos/turbo-rails', branch: 'patch-1'

gem_group :development do
  gem 'foreman'
  gem "hotwire-livereload"
end

gem "acts_as_tenant"
gem "bcrypt"
gem "good_job"

environment "config.hotwire_livereload.listen_paths << Rails.root.join(\"app/assets/builds\")", env: 'development'

# Assume SSL in Production
environment "config.force_ssl = true", env: 'production'
environment "config.assume_ssl = true", env: 'production'

files = Dir[File.expand_path("../files/**/*", __FILE__)]
  .reject { |f| File.directory?(f) }
  .map { |f| f.gsub(File.expand_path("../files", __FILE__) + "/", "") }

files.each do |file_path|
  file file_path, File.read(File.expand_path("../files/#{file_path}", __FILE__))
end

route <<~ROUTE
  resources :configurations, only: [] do
    get "ios_v1", on: :collection
  end
ROUTE

# Add following lines to config/application.rb
#     config.i18n.available_locales = [:en, :pl]
#     config.i18n.default_locale = :en
#
#     config.active_job.queue_adapter = :good_job
run "sed -i '/config.load_defaults 7.1/a \ \ \ \ config.i18n.available_locales = [:en, :pl]' config/application.rb"
run "sed -i '/config.load_defaults 7.1/a \ \ \ \ config.i18n.default_locale = :en' config/application.rb"
run "sed -i '/config.load_defaults 7.1/a \ \ \ \ config.active_job.queue_adapter = :good_job' config/application.rb"

after_bundle do
  run 'bin/setup'
  run 'bin/rails g good_job:install'
  run 'bin/rails db:migrate'

  # Git
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
