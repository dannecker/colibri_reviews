class Colibri::Admin::ReviewSettingsController < Colibri::Admin::BaseController
  before_filter :process_unset_checkboxes, only: [:update]

  def update
    Colibri::Reviews::Config.set(params[:preferences])

    respond_to do |format|
      format.html do
        redirect_to edit_admin_review_settings_path
      end
    end
  end

  def process_unset_checkboxes
    # workaround for unset checkbox behaviour
    params[:preferences] ||= {}
    Colibri::ReviewsConfiguration.boolean_preferences.each do |sym|
      params[:preferences][sym] = false if params[:preferences][sym].blank?
    end
  end
end
