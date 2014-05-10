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
  $div.addClass('clearfix').addClass 'editing'
  $li.append($div[0]);
  $div.append("<textarea></textarea>")
  $div.children("textarea").val $li.find(".content").text()
  $div.append("<a href='#'>Submit</a>")
  $div.children("a").click submitEdit
  

$(".delete").click (e) ->
  e.preventDefault()
  $li = $(e.currentTarget).parents("li")
  id = $li.data("id")

  $.ajax 
    url: document.URL
    data:
      id: id
    method: 'delete'
    success: (response) ->
      document.location.href = '/'

    error: (response) ->
      console.log response
