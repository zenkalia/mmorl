last_chat_id = 0
chat_delay = 1000
chat_timeout = 'scoping~'

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
    clearTimeout(chat_timeout)
    chat_delay = 1000
    chat_timeout = setTimeout( dumb_refresh, chat_delay )
    if $('#chat-input').is(':focus')
      if key.keyCode == 13
        $.ajax({
          url: '/whatever',
          data: {chat: $('#chat-input').val(), last_chat_id: last_chat_id}
        }).done (data) ->
          render(data)
        $('#chat-input').val('')
        $('#chat-input').blur()
      return true
    if key.keyCode == 13
      $('#chat-input').focus()
      return true
    $.ajax({
      url: '/whatever',
      data: {key: key.which, last_chat_id: last_chat_id}
    }).done (data) ->
      render(data)
  chat_timeout = setTimeout( dumb_refresh, chat_delay )
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
  if data.last_chat_id
    last_chat_id = data.last_chat_id
dumb_refresh = ->
  $.ajax({
    url: '/whatever',
    data: {key: 0, last_chat_id: last_chat_id}
  }).done (data) ->
    render(data)
  chat_delay += 1000
  chat_timeout = setTimeout( dumb_refresh, chat_delay )
