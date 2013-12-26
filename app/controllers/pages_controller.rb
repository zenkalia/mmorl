class PagesController < ApplicationController
  def index
  end

  def update
    @key_code = params[:key].to_i

    case(@key_code.chr)
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
    rander = Fixture.where(row: ((current_user.row-1)..(current_user.row+1)), col: ((current_user.col-1)..(current_user.col+1)))

    stuff = {
      new_cells: [
      ],
      new_chats: [
        "i hate people\n",
        "fucking kill everyone\n"
      ]
    }
    rander.each do |f|
      stuff[:new_cells] << {
        bgc: f.bgc,
        fgc: f.fgc,
        cha: f.char,
        row: f.row,
        col: f.col
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
