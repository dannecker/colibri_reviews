class Colibri::Admin::FeedbackReviewsController <  Colibri::Admin::ResourceController
  belongs_to 'colibri/review'
  def index
    @collection = parent.feedback_reviews
  end
end
