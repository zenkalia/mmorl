$(document).ready ->
  $(document).keypress (key) ->
    $.ajax('/whatever').done (data) ->
      $('.game-window').html(data.html) if data.success
    #alert('hello '+key.which)
