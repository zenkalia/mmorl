$(document).ready ->
  $('#game-window').html('')
  for row in [1..20]
    for col in [1..80]
      $('#game-window').append("<span class='cell' id='#{row}x#{col}'>&nbsp;</span>")
    $('#game-window').append('<br/>')
  $('.cell').css('background-color', 'gray')
  $.ajax({
    url: '/refresh',
  }).done (data) ->
    render(data)
  $(document).keypress (key) ->
    $.ajax({
      url: '/whatever',
      data: {key: key.which}
    }).done (data) ->
      render(data)
render = (data) ->
  if data.memory
    $.each data.memory.split(''), (index, char) ->
      cell = $("##{Math.floor(index/80)+1}x#{index%80+1}")
      cell.css('background-color', 'black')
      cell.css('color', 'gray')
      char = "\u00a0" if char == ' '
      cell.text(char)
  if data.new_cells
    $.each data.new_cells, (index, d) ->
      cell = $("##{d.row}x#{d.col}")
      cell.css('background-color', d.bgc)
      cell.css('color', d.fgc)
      cell.text(d.cha)
  if data.new_chats
    $.each data.new_chats, (index, c) ->
      cw = $('#chat-window')
      cw.val( cw.val() + "\n" + c  )
      $('#chat-window').scrollTop($('#chat-window')[0].scrollHeight);
