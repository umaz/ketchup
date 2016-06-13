class AdminController < ApplicationController
  def index
  end

  def list
    @projects = Project.all
  end

  def detail
    @project = Project.find(params[:id])
  end

  def entry
    @entry = Entry.all
  end

  def approval
    @entry = Entry.find(params[:id])
  end

  def reqest
  end

  def confirm
    @project = Project.new(project_params)
    Favorite.create(:count => 0)
    if @project.save
      Entry.destroy(params[:data][:id])
      redirect_to admin_entry_path
    else
      render 'new'
    end
  end

  def reject
    Entry.destroy(params[:data])
    redirect_to admin_entry_path
  end

  def edit
    @project = Project.find(params[:id])
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
    params[:data].permit(:name, :group, :about, :kind)
  end
end
