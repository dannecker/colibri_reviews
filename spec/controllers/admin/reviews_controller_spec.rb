require 'spec_helper'

describe Colibri::Admin::ReviewsController do
  stub_authorization!

  let(:product) { create(:product) }
  let(:review) { create(:review, approved: false) }

  before do
    user = create(:admin_user)
    controller.stub(try_colibri_current_user: user)
  end

  context '#index' do
    it 'list reviews' do
      reviews = [
        create(:review, product: product),
        create(:review, product: product)
      ]
      colibri_get :index, product_id: product.slug
      assigns[:reviews].should =~ reviews
    end
  end

  context '#approve' do
    it 'show notice message when approved' do
      review.update_attribute(:approved, true)
      colibri_get :approve, id: review.id
      response.should redirect_to colibri.admin_reviews_path
      flash[:notice].should eq Colibri.t(:info_approve_review)
    end

    it 'show error message when not approved' do
      Colibri::Review.any_instance.stub(:update_attribute).and_return(false)
      colibri_get :approve, id: review.id
      flash[:error].should eq Colibri.t(:error_approve_review)
    end
  end

  context '#edit' do
    specify do
      colibri_get :edit, id: review.id
      response.status.should eq(200)
    end

    context 'when product is nil' do
      before do
        review.product = nil
        review.save!
      end

      it 'flash error' do
        colibri_get :edit, id: review.id
        flash[:error].should eq Colibri.t(:error_no_product)
      end

      it 'redirect to admin-reviews page' do
        colibri_get :edit, id: review.id
        response.should redirect_to colibri.admin_reviews_path
      end
    end
  end
end
