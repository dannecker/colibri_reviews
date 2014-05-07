require 'spec_helper'

feature 'Reviews', js: true do
  given!(:someone) { create(:user, email: 'ryan@colibri.com') }
  given!(:review) { create(:review, :approved, user: someone) }

  background do
    Colibri::Reviews::Config.include_unapproved_reviews = false
  end

  context 'product with no review' do
    given!(:product_no_reviews) { create(:product) }
    scenario 'informs that no reviews has been written yet' do
      visit colibri.product_path(product_no_reviews)
      expect(page).to have_text Colibri.t(:no_reviews_available)
    end

    # Regression test for #103
    context "shows correct number of previews" do
      background do
        FactoryGirl.create_list :review, 3, product: product_no_reviews, approved: true
        Colibri::Reviews::Config[:preview_size] = 2
      end

      scenario "displayed reviews are limited by the set preview size" do
        visit colibri.product_path(product_no_reviews)
        expect(page.all(".review").count).to eql(2)
      end
    end
  end

  context 'when anonymous user' do
    background do
      Colibri::Reviews::Config.require_login = true
    end

    context 'visit product with review' do
      background do
        visit colibri.product_path(review.product)
      end

      scenario 'should see review title' do
        expect(page).to have_text review.title
      end

      scenario 'can not create review' do
        expect(page).not_to have_text Colibri.t(:write_your_own_review)
      end
    end
  end

  context 'when logged in user' do
    given!(:user) { create(:user) }

    background do
      sign_in_as! user
    end

    context 'visit product with review' do
      background do
        visit colibri.product_path(review.product)
      end

      scenario 'can see review title' do
        expect(page).to have_text review.title
      end

      scenario 'can see create new review button' do
        expect(page).to have_text Colibri.t(:write_your_own_review)
      end

      scenario 'can create new review' do
        click_on Colibri.t(:write_your_own_review)

        expect(page).to have_text Colibri.t(:leave_us_a_review_for, name: review.product.name)

        within '#new_review' do
          click_star(3)

          fill_in 'review_name', with: user.email
          fill_in 'review_title', with: 'Great product!'
          fill_in 'review_review', with: 'Some big review text..'
          click_on 'Submit your review'
        end

        expect(page.find('.flash.notice', text: Colibri.t(:review_successfully_submitted))).to be_true
        expect(page).not_to have_text 'Some big review text..'
      end
    end
  end

  private

  def sign_in_as!(user)
    visit colibri.login_path
    within '#new_colibri_user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Login'
  end

  def click_star(num)
    page.all(:xpath, "//a[@title='#{num} stars']")[0].click
  end
end
