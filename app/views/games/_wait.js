var refresher = (function () {
  function refresh() {
    $.ajax('/games/refresh', {
      dataType: 'html',
      error: function (xhr) {
        console.log("ajax error: " + xhr.status);
      },
      success: function (data) {
        $('#results').html(data);
      },
      complete: function (xhr) {
        setTimeout(refresh, 3000);
      }
    });
  }
  return {
    refresh: refresh,
  };
})();

$(function () {
  refresher.refresh();
});
