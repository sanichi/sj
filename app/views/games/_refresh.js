var refresher = (function() {

  function refresh() {
    $.ajax('/games/waiting.js', {

      dataType: 'script',

      error: function(xhr) {
        console.log("ajax error: " + xhr.status);
      },

      complete: function(xhr) {
        setTimeout(refresh, 2500);
      }

    });
  }

  return {
    refresh: refresh,
  };

})();

$(function() {
  refresher.refresh();
});
