class SearchController < ApplicationController
  def new
  end
  def index
    @results = Search.new.query(params[:search_phrase])
  end
end
