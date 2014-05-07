Colibri::ProductsController.class_eval do
  helper Colibri::ReviewsHelper

  [:avg_rating, :reviews_count].each { |attrib| Colibri::PermittedAttributes.product_attributes << attrib }
end
