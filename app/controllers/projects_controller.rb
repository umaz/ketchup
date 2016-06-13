class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    fav_list
    @favorites = Favorite.all
  end

  def show
    @project = Project.find(params[:id])
    fav_list
    @favorite = Favorite.find(params[:id])
  end

  def fav_detail
    fav
    redirect_to project_path(params[:data])
  end

  def fav_all
    fav
    redirect_to projects_path
  end

  def fav
    @project = Project.find(params[:data])
    if cookies[:fav] == nil
      key = Hash.new
    else
      key = JSON.parse(cookies[:fav])
    end
    key[@project.id] = @project.name
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
    count = Favorite.find(params[:data]).count
    Favorite.update(params[:data], :count => count + 1)
  end

  def fav_remove_in_detail
    fav_remove
    redirect_to project_path(params[:data])
  end

  def fav_remove_in_list
    fav_remove
    redirect_to projects_path
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
    count = Favorite.find(params[:data]).count
    Favorite.update(params[:data], :count => count - 1)
    key = JSON.parse(cookies[:fav])
    key.delete(params[:data])
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
  end

  def new
    @project = Entry.new
  end

  def search
  end

  def create
    @project = Entry.new(project_params)
    if @project.save
      redirect_to projects_list_path
    else
      render 'new'
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to projects_path
    else
      render 'edit'
    end
  end

  private
  def project_params
    params[:project].permit(:name, :group, :about, :kind)
  end
end
