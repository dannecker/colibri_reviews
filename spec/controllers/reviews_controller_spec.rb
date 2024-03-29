require 'spec_helper'

describe Colibri::ReviewsController do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:review_params) do
    { product_id: product.slug,
      review: { rating: 3,
                name: 'Ryan Bigg',
                title: 'Great Product',
                review: 'Some big review text..' } }
  end

  before do
    controller.stub :colibri_current_user => user
    controller.stub :colibri_user_signed_in? => true
  end

  context '#index' do
    context 'for a product that does not exist' do
      it 'responds with a 404' do
        colibri_get :index, product_id: 'not_real'
        response.status.should eq(404)
      end
    end

    context 'for a valid product' do
      it 'list approved reviews' do
        approved_reviews = [
          create(:review, :approved, product: product),
          create(:review, :approved, product: product)
        ]
        colibri_get :index, product_id: product.slug
        assigns[:approved_reviews].should =~ approved_reviews
      end
    end
  end

  context '#new' do
    context 'for a product that does not exist' do
      it 'responds with a 404' do
        colibri_get :new, product_id: 'not_real'
        response.status.should eq(404)
      end
    end

    it 'fail if the user is not authorized to create a review' do
      controller.stub(:authorize!) { raise }
      expect {
        colibri_post :new, product_id: product.slug
        assert_match 'ryanbig', response.body
      }.to raise_error
    end

    it 'render the new template' do
      colibri_get :new, product_id: product.slug
      response.status.should eq(200)
      response.should render_template(:new)
    end
  end

  context '#create' do
    before { controller.stub colibri_current_user: user }

    context 'for a product that does not exist' do
      it 'responds with a 404' do
        colibri_post :create, product_id: 'not_real'
        response.status.should eq(404)
      end
    end

    it 'creates a new review' do
      expect {
        colibri_post :create, review_params
      }.to change(Colibri::Review, :count).by(1)
    end

    it 'sets the ip-address of the remote' do
      request.stub(remote_ip: '127.0.0.1')
      colibri_post :create, review_params
      assigns[:review].ip_address.should eq '127.0.0.1'
    end

    it 'fails if the user is not authorized to create a review' do
      controller.stub(:authorize!) { raise }
      expect{
        colibri_post :create, review_params
      }.to raise_error
    end

    it 'flashes the notice' do
      colibri_post :create, review_params
      flash[:notice].should eq Colibri.t(:review_successfully_submitted)
    end

    it 'redirects to product page' do
      colibri_post :create, review_params
      response.should redirect_to colibri.product_path(product)
    end

    it 'removes all non-numbers from ratings param' do
      colibri_post :create, review_params
      controller.params[:review][:rating].should eq '3'
    end

    it 'sets the current colibri user as reviews user' do
      colibri_post :create, review_params
      review_params[:review].merge!(user_id: user.id)
      assigns[:review][:user_id] = user.id
      assigns[:review][:user_id].should eq user.id
    end

    context 'with invalid params' do
      it 'renders new when review.save fails' do
        Colibri::Review.any_instance.stub(:save).and_return(false)
        colibri_post :create, review_params
        response.should render_template :new
      end

      it 'does not create a review' do
        expect(Colibri::Review.count).to eq 0
        expect {
          colibri_post :create, review_params[:review].merge!({rating: 'not_a_number'})
        }.not_to change(Colibri::Review, :count).by(1)
      end
    end

    # It always sets the locale so preference pointless
    context 'when config requires locale tracking:' do
      it 'sets the locale' do
        Colibri::Reviews::Config.preferred_track_locale = true
        colibri_post :create, review_params
        assigns[:review].locale.should eq I18n.locale.to_s
      end
    end
  end
end
