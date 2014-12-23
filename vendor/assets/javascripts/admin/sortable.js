$(document).ready(function() {
  var fixHelper = function(e, ui) {
    ui.children().each(function() {
      $(this).width($(this).width());
    });
    return ui;
  };
  var $sortable_list = $(".js-sortable-list");

  $sortable_list.sortable({cursor: "move", helper: fixHelper, update: function() {
    var $this = $(this);

    $.ajax({
      type: 'post',
      data: $this.sortable('serialize'),
      dataType: 'json',
      complete: function(request){
        $this.effect('highlight', {}, 500);
      },
      url: $this.data('url')
    })
  }});

  $sortable_list.disableSelection();
});
