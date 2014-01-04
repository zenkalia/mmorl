class PagesController < ApplicationController
  def index
  end

  def update
    @key_code = params[:key].to_i

    rander = current_user.visible_fixtures

    stuff = {
      new_cells: [
      ],
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
    end
    stuff[:new_chats] = msgs

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
