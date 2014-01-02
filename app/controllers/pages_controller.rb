class PagesController < ApplicationController
  def index
  end

  def update
    @key_code = params[:key].to_i

    case(@key_code.chr)
    when 'h'
      msgs = current_user.move(0,-1)
    when 'j'
      msgs = current_user.move(1,0)
    when 'k'
      msgs = current_user.move(-1,0)
    when 'l'
      msgs = current_user.move(0,1)
    when 'y'
      msgs = current_user.move(-1,-1)
    when 'u'
      msgs = current_user.move(-1,1)
    when 'b'
      msgs = current_user.move(1,-1)
    when 'n'
      msgs = current_user.move(1,1)
    end
    rander = current_user.visible_fixtures

    stuff = {
      new_cells: [
      ],
      new_chats: msgs
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
