(function() {
  var submitEdit;

  submitEdit = function(e) {
    var $currentTarget, $li, $textarea, id;
    e.preventDefault();
    $currentTarget = $(e.currentTarget);
    $textarea = $currentTarget.siblings("textarea");
    $li = $currentTarget.parents("li");
    id = $li.data("id");
    return $.ajax({
      url: document.URL,
      data: {
        id: id,
        content: $textarea.val()
      },
      method: 'put',
      success: function(response) {
        return document.location.href = '/';
      },
      error: function(response) {
        return console.log(response);
      }
    });
  };

  $(".create").click(function(e) {
    e.preventDefault();
    return $("form").toggleClass('hidden');
  });

  $(".edit").click(function(e) {
    var $currentTarget, $div, $li;
    e.preventDefault();
    $currentTarget = $(e.currentTarget);
    if ($currentTarget.hasClass('active')) {
      $currentTarget.removeClass('active');
      $currentTarget.siblings(".editing").remove();
      return;
    } else {
      $currentTarget.addClass('active');
    }
    $li = $(e.currentTarget).parents("li");
    $div = $(document.createElement("div"));
    $div.addClass('editing');
    $li.append($div[0]);
    $div.append("<textarea></textarea>");
    $div.children("textarea").val($li.find(".content").text());
    $div.append("<button>Submit</button>");
    $div.append("<div class='clearfix'></div>");
    return $div.children("button").click(submitEdit);
  });

  $(".delete").click(function(e) {
    var $li, id;
    e.preventDefault();
    $(".modal").removeClass('hidden');
    $li = $(e.currentTarget).parents("li");
    id = $li.data("id");
    return $(".delete-id").val(id);
  });

  $(".comfirm").click(function(e) {
    var id, password;
    id = $(this).siblings(".delete-id").val();
    password = $(this).siblings(".password").val();
    return $.ajax({
      url: document.URL,
      data: {
        id: id,
        password: password
      },
      method: 'delete',
      error: function(response) {
        alert('wrong ');
        return console.log(response);
      },
      complete: function() {
        return document.location.href = '/';
      }
    });
  });

}).call(this);
