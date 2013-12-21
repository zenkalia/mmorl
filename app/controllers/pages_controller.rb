class PagesController < ApplicationController
  def index
  end

  def update
    @key_code = params[:key].to_i

    case(@key_code.chr)
    when 'h'
      current_user.update_attribute(:col, current_user.col - 1)
    when 'j'
      current_user.update_attribute(:row, current_user.row + 1)
    when 'k'
      current_user.update_attribute(:row, current_user.row - 1)
    when 'l'
      current_user.update_attribute(:col, current_user.col + 1)
    end
    stuff = {
      new_cells: [
        {
          bgc: :black,
          fgc: :white,
          cha: '@',
          row: current_user.row,
          col: current_user.col
        }
      ]
    }
    respond_to do |format|
      format.json { render :json => stuff }
      format.html { }
    end
  end
end
