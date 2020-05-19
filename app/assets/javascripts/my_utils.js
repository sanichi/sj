// see utils/search/_select.html.haml
$(function() {
  // Auto-submit on change.
  $('form .auto-submit').change(function() {
    $(this).parents('form').submit();
  });
});
