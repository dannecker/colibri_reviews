class Colibri::ReviewsAbility
  include CanCan::Ability

  def initialize user
    review_ability_class = self.class
    can :create, Colibri::Review do |review|
      review_ability_class.allow_anonymous_reviews? || !user.email.blank?
    end
    can :create, Colibri::FeedbackReview do |review|
      review_ability_class.allow_anonymous_reviews? || !user.email.blank?
    end
  end

  def self.allow_anonymous_reviews?
    !Colibri::Reviews::Config[:require_login]
  end
end
