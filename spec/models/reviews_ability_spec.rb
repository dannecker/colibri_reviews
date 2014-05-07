require 'spec_helper'

require "cancan/matchers"

describe Colibri::ReviewsAbility do
  context '.allow_anonymous_reviews?' do
    it 'should depend on Colibri::Reviews::Config[:require_login]' do
      Colibri::Reviews::Config[:require_login] = false
      Colibri::ReviewsAbility.allow_anonymous_reviews?.should be_true
      Colibri::Reviews::Config[:require_login] = true
      Colibri::ReviewsAbility.allow_anonymous_reviews?.should be_false
    end
  end

  context 'permissions' do
    let(:user_without_email) { double(:user, email: nil) }
    let(:user_with_email) { double(:user, email: 'a@b.com') }

    context 'when anonymous reviews are allowed' do
      before do
        Colibri::Reviews::Config[:require_login] = false
      end

      it 'lets anyone create a review or feedback review' do
        [user_without_email, user_with_email].each do |u|
          Colibri::ReviewsAbility.new(u).should be_able_to(:create, Colibri::Review.new)
          Colibri::ReviewsAbility.new(u).should be_able_to(:create, Colibri::FeedbackReview.new)
        end
      end
    end

    context 'when anonymous reviews are not allowed' do
      before do
        Colibri::Reviews::Config[:require_login] = true
      end

      it 'only allows users with an email to create a review or feedback review' do
        Colibri::ReviewsAbility.new(user_without_email).should_not be_able_to(:create, Colibri::Review.new)
        Colibri::ReviewsAbility.new(user_without_email).should_not be_able_to(:create, Colibri::FeedbackReview.new)

        Colibri::ReviewsAbility.new(user_with_email).should be_able_to(:create, Colibri::Review.new)
        Colibri::ReviewsAbility.new(user_with_email).should be_able_to(:create, Colibri::FeedbackReview.new)
      end
    end
  end
end
