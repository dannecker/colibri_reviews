require 'spec_helper'

describe Colibri::Admin::ReviewSettingsController do
  stub_authorization!

  before do
    user = create(:admin_user)
    controller.stub(:try_colibri_current_user => user)
  end

  context '#update' do
    it 'redirects to edit-review-settings page' do
      colibri_put :update, preferences: { preview_size: 4 }
      response.should redirect_to colibri.edit_admin_review_settings_path
    end

    context 'For parameters:
            preview_size: 4,
            show_email: false,
            feedback_rating: false,
            require_login: true,
            track_locale: true' do

      it 'sets preferred_preview_size to 4' do
        colibri_put :update, preferences: { preview_size: 4 }
        Colibri::Reviews::Config.preferred_preview_size.should eq 4
      end

      it 'sets preferred_show_email to false' do
        colibri_put :update, preferences: { show_email: false }
        Colibri::Reviews::Config.preferred_show_email.should be_false
      end

      it 'sets preferred_feedback_rating to false' do
        colibri_put :update, preferences: { feedback_rating: false }
        Colibri::Reviews::Config.preferred_feedback_rating.should be_false
      end

      it 'sets preferred_require_login to true' do
        colibri_put :update, preferences: { require_login: true }
        Colibri::Reviews::Config.preferred_require_login.should be_true
      end

      it 'sets preferred_track_locale to true' do
        colibri_put :update, preferences: { track_locale: true }
        Colibri::Reviews::Config.preferred_track_locale.should be_true
      end
    end
  end

  context '#edit' do
    it 'should render the edit template' do
      colibri_get :edit
      response.should render_template(:edit)
    end
  end
end
