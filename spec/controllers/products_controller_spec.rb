require 'spec_helper'

describe Colibri::ProductsController do
  [:avg_rating, :reviews_count].each do |attrib|
    it "should add #{attrib} to the set of allowed attributes" do
      controller.permitted_product_attributes.should include(attrib)
    end
  end
end
