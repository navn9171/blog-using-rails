class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    # @article = Article.new
    @article = current_user.articles.build
  end

  def create
    # @article = Article.new(article_params)
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: 'Blog Created Successfully.'
    else
      redirect_to :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article, notice: 'Blog Updated Successfully.'
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, notice: 'Blog Destroyed Successfully.' 
  end

  def correct_user
    @article = current_user.articles.find_by(id: params[:id]) #if aticle user_id is != to current user_id then it will be nill.
    redirect_to root_path, notice: "Not Authorized to Edit" if @article.nil?
  end

  private
    def article_params
      params.require(:article).permit(:user_id, :title, :body)
    end

end
