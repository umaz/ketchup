class ProjectsController < ApplicationController
  def index
    if params.include?(:q)
      if params[:q].include?(:name)
        if params[:q][:name] == ""
          @q = Project.search(params[:q])
          @projects = @q.result.page(params[:page])
        else
          conversion
          search
          @q = Project.search(:id_eq_any => @sort, :s => params[:q][:s])
          if @q.sorts.empty?
            if @sort.empty?
              @q = Project.search(:id_eq => 0)
              @projects = @q.result.page(params[:page])
            else
              @projects = Project.page(params[:page]).where(id: @sort).where(id: @sort).order("field(id, #{@sort.join(',')})")
            end
          else
            @projects = @q.result.page(params[:page])
          end
        end
      else
        @q = Project.search(params[:q])
        @projects = @q.result.page(params[:page])
      end
    else
      @q = Project.search(params[:q])
      @projects = @q.result.page(params[:page])
    end
    fav_list
    @project = Project.all.sample
  end

  def show
    @project = Project.find(params[:id])
    fav_list
    detail
    search
    @sort.delete(params[:id].to_i)
    if @sort.empty?
      @q = Project.search(:id_eq => 0)
      @projects = @q.result.page(params[:page])
    else
      @sort = @sort.take(5)
      @projects = Project.page(params[:page]).where(id: @sort).where(id: @sort).order("field(id, #{@sort.join(',')})")
    end
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
    mecab = Natto::MeCab.new(node_format:'%m,%f[6],%f[7],%f[8],%f[0]$$', unk_format:"%M,名詞$$", eos_format:"")
    @value = params[:q][:name]
    @result = mecab.parse(@value)
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

  def search
    if @search.empty?
      @sort = []
    else
      @b = Search.search(:word_cont_any => @search)
      @before = @b.result
      @r = Hash.new(0)
      @before.each do |sum|
        @r[sum.project_id] += sum.tfidf
      end
      @sort = @r.sort{|(k1, v1), (k2, v2)| v2 <=> v1 }
      @sort.each do |del|
        del.pop
      end
      @sort.flatten!
    end
  end

  private
  def project_params
    params[:project].permit(:name, :kana, :about, :detail, :kind)
  end
end
