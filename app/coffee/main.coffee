submitEdit = (e) ->
  e.preventDefault()
  $currentTarget = $(e.currentTarget)
  $textarea = $currentTarget.siblings("textarea")
  $li = $currentTarget.parents("li")
  id = $li.data("id")
  $.ajax 
    url: document.URL
    data:
      id: id
      content: $textarea.val()
    method: 'put'
    success: (response) ->
      document.location.href = '/'

    error: (response) ->
      console.log response

$(".create").click (e) ->
  e.preventDefault()
  $("form").toggleClass 'hidden'

$(".edit").click (e) ->
  e.preventDefault()
  $currentTarget = $(e.currentTarget)
  if $currentTarget.hasClass 'active'
    $currentTarget.removeClass 'active'
    $currentTarget.siblings(".editing").remove()
    return
  else
    $currentTarget.addClass 'active'

  $li = $(e.currentTarget).parents("li")
  $div = $(document.createElement("div"))
  $div.addClass 'editing'
  $li.append($div[0]);
  $div.append("<textarea></textarea>")
  $div.children("textarea").val $li.find(".content").text()
  $div.append("<button>Submit</button>")
  $div.append("<div class='clearfix'></div>")  
  $div.children("button").click submitEdit
  

$(".delete").click (e) ->
  e.preventDefault()
  $(".modal").removeClass 'hidden'
  $li = $(e.currentTarget).parents("li")
  id = $li.data("id")
  $(".delete-id").val id

$(".comfirm").click (e) ->
  id = $(this).siblings(".delete-id").val()
  password = $(this).siblings(".password").val()
  $.ajax 
    url: document.URL
    data:
      id: id
      password: password
    method: 'delete'
    # success: (response) ->
    #   document.location.href = '/'

    error: (response) ->
      alert 'wrong '
      console.log response

    complete: ->
      document.location.href = '/'
