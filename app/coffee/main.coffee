JST = 
  'editBlock': "<div class='editing hidden'><textarea></textarea><button>Submit</button><div class='clearfix'></div></div>"

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
  $("form").slideToggle()

$(".edit").click (e) ->
  e.preventDefault()
  $currentTarget = $(e.currentTarget)
  if $currentTarget.hasClass 'active'
    $currentTarget.removeClass 'active'
    $currentTarget.siblings(".editing").slideUp ->
      $currentTarget.siblings(".editing").remove()
    return
  else
    $currentTarget.addClass 'active'

  $li = $(e.currentTarget).parents("li")
  $li.append JST['editBlock']
  $li.find("textarea").val $li.find(".content").text()
  $li.find(".editing").slideDown()
  $li.find("button").click submitEdit
  

$(".delete").click (e) ->
  e.preventDefault()
  $(".modal").removeClass 'hidden'
  $li = $(e.currentTarget).parents("li")
  id = $li.data("id")
  $(".delete-id").val id

$(".cancel").click (e) ->
  e.preventDefault()
  $(".modal").addClass 'hidden'
  $(".delete-id").val ""

$(".comfirm").click (e) ->
  id = $(this).siblings(".delete-id").val()
  password = $(this).siblings(".password").val()
  $.ajax 
    url: document.URL
    data:
      id: id
      password: password
    method: 'delete'

    error: (response) ->
      alert 'wrong '
      console.log response

    complete: ->
      document.location.href = '/'
