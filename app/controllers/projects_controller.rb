class ProjectsController < ApplicationController
  def index
    if params[:kind] != nil
      if session[:back] == nil
        @value = params[:kind]
        if params.include?(:q)
          @q = Project.search(:kind1_or_kind2_eq => params[:kind], :s => params[:q][:s])
        else
          @q = Project.search(:kind1_or_kind2_eq => params[:kind])
        end
          @projects = @q.result.page(params[:page])
      else
        @s = session[:back]
        if params.include?(:q)
          @q = Project.search(:id_eq_any => @s, :s => params[:q][:s])
        else
          @q = Project.search(:id_eq_any => @s)
        end
        @projects = Project.page(params[:page]).where(id: @s).where(id: @s).order("field(id, #{@s.join(',')})")
      end
    else
      if session[:back] == nil
        if params.include?(:q)
          if params[:q].include?(:name)
            if params[:q][:name] == ""
              @q = Project.search(params[:q])
              @projects = @q.result.page(params[:page])
            else
              conversion
              search
              @q = Project.search(:id_eq_any => @sort, :s => params[:q][:s])
              if @sort.empty?
                @q = Project.search(:id_eq => 0)
                @projects = @q.result.page(params[:page])
              else
                if @q.sorts.empty?
                  @projects = Project.page(params[:page]).where(id: @sort).where(id: @sort).order("field(id, #{@sort.join(',')})")
                else
                  @projects = @q.result.page(params[:page])
                end
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
      else
        @s = session[:back]
        @q = Project.search(:id_eq_any => @s, :s => params[:q][:s])
        @projects = Project.where(id: @s).where(id: @s).order("field(id, #{@s.join(',')})")
      end
    end
    session[:back] = nil
    fav_list
    if cookies[:kind] == nil
      @project = Project.all.sample
    elsif cookies[:kind] == ""
      @project = Project.all.sample
    else
      @project = Project.where(kind1: cookies[:kind].split(/&/)).sample
    end
  end

  def show
    @project = Project.find(params[:id])
    detail
    search
    fav_list
    @sort.delete(params[:id].to_i)
    if @sort.empty?
      @q = Project.search(:id_eq => 0)
      @projects = @q.result
    else
      @sort = @sort.take(5)
      @projects = Project.where(id: @sort).where(id: @sort).order("field(id, #{@sort.join(',')})")
    end
  end

  def refine
    @q = Project.search(:kind1_or_kind2_eq => params[:data])
    @projects = @q.result.page(params[:page])
    fav_list
  end

  def fav
    @project = Project.find(params[:data][:id])
    if cookies[:fav] == nil
      key = Hash.new
    else
      key = JSON.parse(cookies[:fav])
    end
    key[@project.id] = @project.name
    cookies.permanent[:fav] = {:value => key.to_json}
    count = @project.count
    Project.update(@project.id, :count => count + 1)
    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

  def fav_remove
    @project = Project.find(params[:data][:id])
    count = @project.count
    Project.update(@project.id, :count => count - 1)
    key = JSON.parse(cookies[:fav])
    key.delete(params[:data][:id])
    cookies.permanent[:fav] = {:value => key.to_json}
    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
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
    @kind1s = Kind1.all
  end

  def kind2_select
    @kind2s = Kind2.where(kind1_id: params[:kind1_id]).pluck(:kind2, :id)
   # 初期値
    @kind2s.unshift(["選択してください。", ""])
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
    require 'nkf'
    mecab = Natto::MeCab.new(node_format:'%m$$', unk_format:"%M$$", eos_format:"")
    @kana = NKF.nkf('-w -h2', params[:q][:name])
    @value = NKF.nkf('-w -m0Z1', params[:q][:name])
    @word = @value + ' ' + @kana
    @result = mecab.parse(@kana)
    @search = @result.split(/\$\$/)
    @search.map! do |del|
      del.gsub(/\s|　/,"")
    end
    @search.delete_if do |del|
      del =~ /^$/
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

  def setup
  end

  def kind
    if params.include?('checked_param')
      if params[:checked_param].include?('全て')
        cookies.permanent[:kind] = nil
      else
        cookies.permanent[:kind] = params[:checked_param]
      end
    else
      cookies.permanent[:kind] = nil
    end
    redirect_to index_path
  end

  private
  def project_params
    params[:project].permit(:name, :kana, :about, :detail, :kind)
  end
end
