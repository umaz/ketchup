class ProjectsController < ApplicationController
  def index
    @project = Project.all.sample
  end

  def list
    @projects = Project.all
    fav_list
    @favorites = Favorite.all
  end

  def detail
    @project = Project.find(params[:id])
    fav_list
    @favorite = Favorite.find(params[:id])
  end

  def fav_detail
    fav
    redirect_to detail_path(params[:data])
  end

  def fav_all
    fav
    redirect_to projects_detail_path
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
    redirect_to detail_path(params[:data])
  end

  def fav_remove_in_fav_list
    fav_remove
    redirect_to projects_fav_list_path
  end

  def fav_remove_in_list
    fav_remove
    redirect_to projects_detail_path
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
  end

  def search
  end

  def create
    new_project = params.require(:project).permit(
      :name, :group, :about, :kind
    )
    Entry.create(new_project)
      redirect_to '/projects/detail'
  end

  def admin
    @entry = Entry.all
  end

  def admin_detail
    @entry = Entry.find(params[:id])
  end

  def confirm
    new_project = params.require(:data).permit(
      :name, :group, :about, :kind
    )
    Project.create(new_project)
    Favorite.create(:count => 0)
    Entry.destroy(params[:data][:id])
    redirect_to '/projects/detail'
  end

  def reject
    Entry.destroy(params[:data])
    redirect_to '/projects/admin'
  end
end
