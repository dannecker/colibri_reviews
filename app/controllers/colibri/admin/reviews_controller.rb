class Colibri::Admin::ReviewsController < Colibri::Admin::ResourceController
  helper Colibri::ReviewsHelper

  def index
    @reviews = collection
  end

  def approve
    r = Colibri::Review.find(params[:id])

    if r.update_attribute(:approved, true)
       flash[:notice] = Colibri.t("info_approve_review")
    else
       flash[:error] = Colibri.t("error_approve_review")
    end
    redirect_to admin_reviews_path
  end

  def edit
    if @review.product.nil?
      flash[:error] = Colibri.t("error_no_product")
      redirect_to admin_reviews_path and return
    end
  end

  private

  def collection
    params[:q] ||= {}

    @search = Colibri::Review.ransack(params[:q])
    @collection = @search.result.includes([:product, :user, :feedback_reviews]).page(params[:page]).per(params[:per_page])
  end
end
