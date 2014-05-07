class AddLocaleToReviews < ActiveRecord::Migration
  def self.up
    add_column :colibri_reviews, :locale, :string, :default => 'en'
  end

  def self.down
    remove_column :colibri_reviews, :locale
  end
end
