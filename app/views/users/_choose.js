$(function() {
  $('#user_id').change(function() {
    window.location.href = '/users/' + $(this).val() + '/scores';
  });
});
