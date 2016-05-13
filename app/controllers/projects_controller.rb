class ProjectsController < ApplicationController
  def index
    @project = Project.all.sample
    gon.project_name = @project.name
    gon.project_id = @project.id
  end

  def list
    @projects = Project.all
  end

  def detail
    @project = Project.find_by(name: params[:name])
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
