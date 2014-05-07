module ColibriReviews
  class Engine < Rails::Engine
    require 'colibri/core'
    isolate_namespace Colibri
    engine_name 'colibri_reviews'

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Colibri::Ability.register_ability(Colibri::ReviewsAbility)
    end
    config.to_prepare &method(:activate).to_proc

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
