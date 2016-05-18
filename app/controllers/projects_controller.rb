class ProjectsController < ApplicationController
  def index
    @project = Project.all.sample
  end

  def list
    @projects = Project.all
  end

  def detail
    @project = Project.find_by(name: params[:name])
    def fav
      if cookies[:fav] == nil
        key = Array.new
      else
        key = JSON.parse(cookies[:fav])
      end
      key.push(params[:data])
      cookies[:fav] = {:value => key.uniq.to_json, :expires => 20.year.from_now }
      redirect_to detail_path(params[:data])
    end
  end

  def fav_list
    @lists = JSON.parse(cookies[:fav])
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
