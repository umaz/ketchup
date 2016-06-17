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
    detail
    @q = Project.search(:name_or_kana_or_about_or_detail_or_kind_cont_any => @search)
    @projects = @q.result.page(params[:page])
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
      mecab = Natto::MeCab.new(node_format:'%m$$', unk_format:"%M$$", eos_format:"")
      @value = params[:q][:name]
      @result = mecab.parse(@value)
      @search = @result.split(/\$\$/)
      @search.map! do |del|
        del.gsub(/\s|　/,"")
      end
      @search.delete_if do |del|
        del =~ /^$/
      end
    else
      @search = nil
    end
  end

  def detail
    mecab = Natto::MeCab.new(node_format:'%m,%f[6],%f[7],%f[8],%f[0]$$', unk_format:"%M,名詞$$", eos_format:"")
    word = @project.name + ',' + @project.about + ',' + @project.detail
    @result = mecab.parse(word)
    @result = @result.split(/\$\$/)
      @s = @result.select do |word|
      word =~ /,名詞|,動詞|,形容詞/
      end
      @s.map! do |str|
        str.split(/,/)
      end
      @s.each do |pop|
        pop.pop
      end
      @s.flatten!
      @search = @s.uniq
      @search.delete_if do |del|
        del =~ /^$|\.|\(|\)/
      end
  end

  private
  def project_params
    params[:project].permit(:name, :kana, :about, :detail, :kind)
  end
end
