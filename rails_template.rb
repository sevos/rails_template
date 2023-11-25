# remove gem "turbo-rails" from Gemfile
run "sed -i '/gem \"turbo-rails\"/d' Gemfile"

# Gems
gem 'turbo-rails', github: 'sevos/turbo-rails', branch: 'patch-1'

gem_group :development do
  gem 'foreman'
  gem "hotwire-livereload"
end

environment "config.hotwire_livereload.listen_paths << Rails.root.join(\"app/assets/builds\")", env: 'development'

# Assume SSL in Production
environment "config.force_ssl = true", env: 'production'
environment "config.assume_ssl = true", env: 'production'

files = %w[
  app/builders/application_form_builder.rb
  config/tailwind.config.js
  app/controllers/application_controller.rb
  app/controllers/configurations_controller.rb
  app/controllers/concerns/application_controller/with_locale_from_request.rb
  app/helpers/application_helper.rb
  app/models/current.rb
]

files.each do |file_path|
  file file_path, File.read(File.expand_path("../#{file_path}", __FILE__))
end

route <<~ROUTE
  resources :configurations, only: [] do
    get "ios_v1", on: :collection
  end
ROUTE

after_bundle do
  run 'bin/setup'
  run "rails livereload:install"

  run "sed -i 's/<html>/<html <%= \"data-turbo-native-app\" if turbo_native_app? %> >/g' app/views/layouts/application.html.erb"
  run "sed -i '/<\\/head>/i <%= yield :head %>' app/views/layouts/application.html.erb"

  # Git
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
