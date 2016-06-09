class ProjectsController < ApplicationController
  def index
    @project = Project.all.sample
  end

  def list
    @projects = Project.all
  end

  def detail
    @project = Project.find_by(id: params[:id])
    fav_list
  end

  def fav
    @project = Project.find_by(id: params[:data])
    if cookies[:fav] == nil
      key = Hash.new
    else
      key = JSON.parse(cookies[:fav])
    end
    key[@project.id] = @project.name
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
    redirect_to detail_path(params[:data]), notice: "お気に入り登録しました"
  end

  def fav_remove_in_detail
    fav_remove
    redirect_to detail_path(params[:data])
  end

  def fav_remove_in_list
    fav_remove
    redirect_to projects_fav_list_path
  end

  def fav_list
    if cookies[:fav] == nil
      @lists = Hash.new
    else
      @lists = JSON.parse(cookies[:fav])
    end
  end

  def fav_delete
    cookies.delete(:fav)
    redirect_to projects_index_path
  end

  def fav_remove
    key = JSON.parse(cookies[:fav])
    key.delete(params[:data])
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
  end

  def new
  end

  def search
  end

  def create
    new_project = params.require(:project).permit(
      :name, :group, :about, :kind
    )
    @project = Project.create(new_project)
    redirect_to '/projects/list'
  end
end
