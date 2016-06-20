class AdminController < ApplicationController
before_filter :auth
before_action :set_project, only: [:detail, :edit]

  def index
  end

  def list
    @projects = Project.all
  end

  def detail
  end

  def entries
    @entry = Entry.all
  end

  def approval
    @entry = Entry.find(params[:id])
  end

  def reqest
  end

  def confirm
    @project = Project.new(project_params)
    if @project.save
      Entry.destroy(params[:data][:id])
      redirect_to admin_entries_path
    else
      render 'new'
    end
  end

  def reject
    Entry.destroy(params[:data])
    redirect_to admin_entries_path
  end

  def edit
  end

  def destroy
    Project.destroy(params[:data])
    redirect_to admin_list_path
  end

  def make
    mecab = Natto::MeCab.new(node_format:'%m,%f[6],%f[7],%f[8],%f[0]$$', unk_format:"%M,名詞$$", eos_format:"")
    @tfidf = Hash.new { |h,k| h[k] = {} }
    @projects = Project.all
    @projects.each do |s|
      @word = (s.name + ", ") * 100 + (s.about + ", ") * 10 + s.kana + ", " + s.detail + ", " + (s.synonym + ", ") * 100 + (s.kind1 + ", ") * 50 + (s.kind2 + ", ") * 50
      @result = mecab.parse(@word)
      @result = @result.split(/\$\$/)
      @ti = @result.select do |word|
        word =~ /,名詞|,動詞|,形容詞/
      end
      @ti.map! do |str|
        str.split(/,/)
      end
      @ti.each do |pop|
        pop.pop
      end
      @ti.flatten!
      @ti.delete_if do |del|
        del =~ /^$|\.|\(|\)/
      end
      @word_store = Hash.new(0)
      @ti.each do |count|
        @word_store[count] += 1
      end
      sum = 0
      @word_store.each_value do |v|
        sum += v
      end
      @word_store.each do |k, v|
    		@word_store[k] = (v/sum.to_f)
    	end
      @word_store.sort.each do |k, v|
    		@tfidf[s.id][k] = v
      end
    end
    l = @tfidf.length.to_f
    word = Array.new
    @tfidf.each_value do |v|
    	word += v.keys
    end
    idf = Hash.new(0)
    word.each do |h|
    	idf[h] += 1
    end
    idf.each do |k, v|
    	@tfidf.each_value do |value|
    		if value.include?(k)
    			value[k] = value[k] * (Math.log(l.to_f/v) + 1)
    		end
    	end
    end
    @search = Array.new
    @tfidf.each do |k, v|
    	v.each do |key, val|
    		data = Hash.new
    		data[:project_id] = k
    		data[:word] = key
        data[:tfidf] = val
    	  @search.push(data)
    	end
    end
    Search.delete_all
    Search.create(@search)
    redirect_to admin_word_list_path
  end

  def word_list
    @searches = Search.all
  end

  private
  def set_project
  @project = Project.find(params[:id])
  end

  def project_params
    params[:data].permit(:name, :kana, :about, :detail, :kind)
  end
  def auth
    authenticate_or_request_with_http_digest('') do | name |
      u = Admin.find_by_name(name)
      if u
        u.password
      else
        nil
      end
    end
  end
=end
end
