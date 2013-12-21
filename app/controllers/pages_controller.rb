class PagesController < ApplicationController
  def index
  end

  def update
    @key = params[:key].to_i.chr
    stuff = [
      {
        bgc: :black,
        fgc: :white,
        cha: 'e',
        row: 1,
        col: 1
      }
    ]
    respond_to do |format|
      format.json { render :json => stuff }
      format.html { }
    end
  end
end
