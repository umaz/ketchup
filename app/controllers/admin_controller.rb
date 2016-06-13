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
    new_project = params.require(:data).permit(
      :name, :group, :about, :kind
    )
    Project.create(new_project)
    Favorite.create(:count => 0)
    Entry.destroy(params[:data][:id])
    redirect_to admin_entry_path
  end

  def reject
    Entry.destroy(params[:data])
    redirect_to admin_entry_path
  end
end
