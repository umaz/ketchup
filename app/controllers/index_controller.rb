class IndexController < ApplicationController
  def index
    @q = Project.search(params[:q])
    @projects = @q.result
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
    @project = Project.find(params[:data])
    count = @project.count
    Project.update(@project.id, :count => count - 1)
    key = JSON.parse(cookies[:fav])
    key.delete(params[:data])
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
  end
end
