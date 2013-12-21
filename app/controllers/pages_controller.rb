class PagesController < ApplicationController
  def index
  end

  def update
    @key_code = params[:key]
    respond_to do |format|
      format.json { render :json => {:success => true, :html => (render_to_string 'pages/update', layout: false)} }
      format.html { }
    end
  end
end
