class ProjectsController < ApplicationController
  def index
    if params.include?(:q)
      conversion
      @q = Project.search(:name_or_kana_or_about_or_detail_or_kind_cont_all => @search, :s => params[:q][:s])
    else
      @q = Project.search(params[:q])
    end
    @projects = @q.result.page(params[:page]).per(100)
    fav_list
    @project = Project.all.sample
  end

  def show
    @project = Project.find(params[:id])
    fav_list
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
    count = @project.count
    Project.update(@project.id, :count => count + 1)
    redirect_to(:back)
  end

  def fav_remove
    @project = Project.find(params[:data])
    count = @project.count
    Project.update(@project.id, :count => count - 1)
    key = JSON.parse(cookies[:fav])
    key.delete(params[:data])
    cookies[:fav] = {:value => key.to_json, :expires => 20.year.from_now }
    redirect_to(:back)
  end

  def fav_list
    if cookies[:fav] == nil
      @lists = Hash.new
    else
      @lists = JSON.parse(cookies[:fav])
    end
  end

  def new
    @project = Entry.new
  end

  def create
    @project = Entry.new(project_params)
    if @project.save
      redirect_to projects_path
    else
      render 'new'
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to admin_list_path
    else
      render 'edit'
    end
  end

  def conversion
    if params[:q].include?(:name)
      advance = "node_format:'%m,%f[6],%f[7],%f[8],%f[0]\n'"
      normal = "node_format:'%m'"
      mecab = Natto::MeCab.new(node_format:'%m\n', unk_format:"%M", eos_format:"")
      @value = params[:q][:name]
      @result = mecab.parse(params[:q][:name])
      @search = @result.split(/\n/)
    else
      @search = nil
    end
  end

  private
  def project_params
    params[:project].permit(:name, :kana, :about, :detail, :kind)
  end
end
