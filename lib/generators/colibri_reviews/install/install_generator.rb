module ColibriReviews
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
        append_file "vendor/assets/javascripts/colibri/frontend/all.js", "//= require colibri/frontend/colibri_reviews\n"
        append_file "vendor/assets/javascripts/colibri/backend/all.js", "//= require colibri/backend/colibri_reviews\n"
      end

      def add_stylesheets
        inject_into_file "vendor/assets/stylesheets/colibri/frontend/all.css", " *= require colibri/frontend/colibri_reviews\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=colibri_reviews'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
