class IndexController < ApplicationController
  def index
    @project = Project.all.sample
  end

  def fav_list
    if cookies[:fav] == nil
      @lists = Hash.new
    else
      @lists = JSON.parse(cookies[:fav])
    end
  end

  def fav_remove_in_fav_list
    fav_remove
    redirect_to index_fav_list_path
  end

  def fav_remove
    count = Favorite.find(params[:data]).count
    Favorite.update(params[:data], :count => count - 1)
    key = JSON.parse(cookies[:fav])
    key.delete(params[:data])
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
  end
end
