class Colibri::Review < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :user, :class_name => Colibri.user_class.to_s
  has_many   :feedback_reviews

  after_save :recalculate_product_rating, :if => :approved?
  after_destroy :recalculate_product_rating

  validates :name, presence: true
  validates :review, presence: true

  validates :rating, numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1, 
                                     less_than_or_equal_to: 5,
                                     message: Colibri.t('you_must_enter_value_for_rating') }


  default_scope { order("colibri_reviews.created_at DESC") }
  
  scope :localized, ->(lc) { where('colibri_reviews.locale = ?', lc) }
  scope :most_recent_first, -> { order('colibri_reviews.created_at DESC') }
  scope :oldest_first, -> { reorder('colibri_reviews.created_at ASC') }
  scope :preview, -> { limit(Colibri::Reviews::Config[:preview_size]).oldest_first }
  scope :approved, -> { where(approved: true) }
  scope :not_approved, -> { where(approved: false) }
  scope :default_approval_filter, -> { Colibri::Reviews::Config[:include_unapproved_reviews] ? all : approved }

  def feedback_stars
    return 0 if feedback_reviews.size <= 0
    ((feedback_reviews.sum(:rating) / feedback_reviews.size) + 0.5).floor
  end

  def recalculate_product_rating
    self.product.recalculate_rating if product.present?
  end
end
