//= require jquery.rating
//= require colibri/backend

// Navigating to a page with ratings via TurboLinks shows the radio buttons
$(document).on('page:load', function () {
  $('input[type=radio].star').rating();
});
