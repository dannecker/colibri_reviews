colibri_reviews
===============

Installation
------------

`Gemfile` to install from git:
```ruby
gem 'colibri_reviews', github: 'colibri/colibri_reviews', branch: 'master'
```

Now bundle it:

    `bundle`
    `rails g colibri_reviews:install`
    `rake db:migrate`

    

Usage
-----

Action "submit" in "reviews" controller - goes to review entry form

Users must be logged in to submit a review

Three partials:
 - `app/views/colibri/products/_rating.html.erb` -- display number of stars
 - `app/views/colibri/products/_shortrating.html.erb` -- shorter version of above
 - `app/views/colibri/products/_review.html.erb` -- display a single review

Administrator can edit and/or approve and/or delete reviews.

Implementation
--------------

Reviews table is quite obvious - and note the "approved" flag which is for the
administrator to update.

Ratings table holds current fractional value - avoids frequent recalc...
