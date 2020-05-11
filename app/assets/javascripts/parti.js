$(document).on('ready show.bs closed.bs load page:change turbolinks:load', function () {
  $.onmount();

  initializeSummernote();

  $('[data-toggle="offcanvas"]').on('click', function () {
    $('.offcanvas-collapse').toggleClass('open');
  })

  $('.infinite-scroll').infiniteScroll({
    path: ".pagination a[rel=next]",
    append: ".infinite-scroll-item",
    prefill: true,
    debug: true
  });
});

$(document).on('turbolinks:before-cache', function () { $.onmount.teardown() });

$.onmount('.js-tooltip', function () { $(this).tooltip() });