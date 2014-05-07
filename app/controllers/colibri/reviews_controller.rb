class Colibri::ReviewsController < Colibri::StoreController
  helper Colibri::BaseHelper
  before_filter :load_product, :only => [:index, :new, :create]
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def index
    @approved_reviews = Colibri::Review.approved.where(product: @product)
  end

  def new
    @review = Colibri::Review.new(:product => @product)
    authorize! :create, @review
  end

  # save if all ok
  def create
    params[:review][:rating].sub!(/\s*[^0-9]*\z/,'') unless params[:review][:rating].blank?

    @review = Colibri::Review.new(review_params)
    @review.product = @product
    @review.user = colibri_current_user if colibri_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Colibri::Reviews::Config[:track_locale]

    authorize! :create, @review
    if @review.save
      flash[:notice] = Colibri.t('review_successfully_submitted')
      redirect_to colibri.product_path(@product)
    else
      render :new
    end
  end

  private

  def load_product
    @product = Colibri::Product.friendly.find(params[:product_id])
  end

  def permitted_review_attributes
    [:rating, :title, :review, :name]
  end

  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end

end
