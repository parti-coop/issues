//= require rails-ujs
//= require activestorage
//= require jquery3
//= require jquery_ujs
//= require onmount
//= require popper
//= require bootstrap
//= require bootstrap3-typeahead.min
//= require bootstrap-autocomplete-input
//= require bootstrap-autocomplete-input-init
//= require cocoon
//= require jquery-ui/widgets/sortable
//= require rails_sortable
//= require summernote/summernote-bs4.min
//= require summernote-slowalk
//= require turbolinks

$(document).on('ready show.bs closed.bs load page:change turbolinks:load', function () {
  $.onmount();
  initializeSummernote();
});

$(document).on('turbolinks:before-cache', function () { $.onmount.teardown() });

$.onmount('.js-tooltip', function () { $(this).tooltip() });