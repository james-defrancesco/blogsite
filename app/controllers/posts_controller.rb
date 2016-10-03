class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    post = find_post
    unless current_user.id == post.user_id
      flash[:notice] = "You don't have access to delete this"
      redirect_to root_path
      return
    end
    @post.destroy
    redirect_to root_path
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def check_post_for_deletion
    @post = Post.find params[:id]
    unless current_user.id == @post.user_id
      flash[:notice] = "You don't have access to delete this"
      redirect_to root
      return
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
