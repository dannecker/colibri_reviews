class RecalculateRatings < ActiveRecord::Migration
  def up
    Colibri::Product.reset_column_information

    Colibri::Product.update_all :reviews_count => 0
    
    Colibri::Product.joins(:reviews).where("colibri_reviews.id IS NOT NULL").find_each do |p|
      Colibri::Product.update_counters p.id, :reviews_count => p.reviews.approved.length

      # recalculate_product_rating exists on the review, not the product
      if p.reviews.approved.count > 0
        p.reviews.approved.first.recalculate_product_rating
      end

    end
  end

  def down
  end
end
