$(document).ready ->
  $(document).keypress (key) ->
    $.ajax({
      url: '/whatever',
      data: {key: key.which}
    }).done (data) ->
      $('.game-window').html(data.html) if data.success
    #alert('hello '+key.which)
