$(document).ready ->
  $(document).keypress (key) ->
    $.ajax('/whatever').done (data) ->
      $('.game-window').html(data)
    #alert('hello '+key.which)
