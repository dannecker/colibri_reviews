class NamespaceTables < ActiveRecord::Migration
  def change
    rename_table :reviews, :colibri_reviews
    rename_table :feedback_reviews, :colibri_feedback_reviews
  end
end
