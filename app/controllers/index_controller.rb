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
end
