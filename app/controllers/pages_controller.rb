class PagesController < ApplicationController
  def index
  end

  def update
    @chat = params[:chat]
    @last_chat_id = params[:last_chat_id]
    @key_code = params[:key].to_i

    ChatMessage.create(public_body: "#{current_user.nick} > #{@chat}") if @chat

    rander = current_user.remembered_fixtures

    stuff = {
      new_cells: [],
      new_chats: []
    }
    rander.each do |f|
      stuff[:new_cells] << {
        bgc: 'black',
        fgc: 'gray',
        cha: f[:cha],
        row: f[:row],
        col: f[:col]
      }
    end

    msgs = case(@key_code.chr)
    when 'h'
      current_user.move(0,-1)
    when 'j'
      current_user.move(1,0)
    when 'k'
      current_user.move(-1,0)
    when 'l'
      current_user.move(0,1)
    when 'y'
      current_user.move(-1,-1)
    when 'u'
      current_user.move(-1,1)
    when 'b'
      current_user.move(1,-1)
    when 'n'
      current_user.move(1,1)
    when '>'
      current_user.enter
      stuff[:memory] = user.memory.fixtures
      stuff[:new_cells] = []
    when '<'
      current_user.enter
      stuff[:memory] = Memory.where(user: current_user, room: current_user.room).first_or_create.fixtures
      stuff[:new_cells] = []
    when '.'
      current_user.move(0,0)
    when ','
      current_user.pickup
    end
    stuff[:new_chats] += msgs.to_a # FIXME

    current_user.room.reload # do i need this?  the state of the room can change i guess...
    rander = current_user.visible_fixtures

    rander.each do |f|
      stuff[:new_cells] << {
        bgc: 'black',
        fgc: 'lightgray',
        cha: f[:cha],
        row: f[:row],
        col: f[:col]
      }
    end

    stuff[:new_cells] << {
      bgc: :black,
      fgc: :white,
      cha: '@',
      row: current_user.row,
      col: current_user.col
    }

    chat_meta = ChatMessage.where('created_at > ?', Time.now - 5.minutes).where('id > ?', @last_chat_id.to_i)
    chat_meta.each do |c|
      stuff[:new_chats] << c.message_for(current_user)
      stuff[:last_chat_id] = c.id
    end

    respond_to do |format|
      format.json { render :json => stuff }
      format.html { }
    end
  end

  def refresh
    stuff = {
      new_cells: [],
    }
    stuff[:memory] = Memory.where(user: current_user, room: current_user.room).first_or_create.fixtures

    rander = current_user.visible_fixtures

    rander.each do |f|
      stuff[:new_cells] << {
        bgc: 'black',
        fgc: 'lightgray',
        cha: f[:cha],
        row: f[:row],
        col: f[:col]
      }
    end

    stuff[:new_cells] << {
          bgc: :black,
          fgc: :white,
          cha: '@',
          row: current_user.row,
          col: current_user.col
        }

    respond_to do |format|
      format.json { render :json => stuff }
      format.html { }
    end
  end
end
