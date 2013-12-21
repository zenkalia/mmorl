$(document).ready ->
  $('#game-window').html('')
  for row in [1..20]
    for col in [1..80]
      $('#game-window').append("<span id='#{row}x#{col}'>&nbsp;</span>")
    $('#game-window').append('<br/>')
  $(document).keypress (key) ->
    $.ajax({
      url: '/whatever',
      data: {key: key.which}
    }).done (data) ->
      $.each data, (index, d) ->
        cell = $("##{d.row}x#{d.col}")
        cell.css('background-color', d.bgc)
        cell.css('color', d.fgc)
        cell.text(d.cha)
    #alert('hello '+key.which)
