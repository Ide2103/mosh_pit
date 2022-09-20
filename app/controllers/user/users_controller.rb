class User::UsersController < ApplicationController
  before_action :authenticate_user!


  def index
    @users = User.all
    @user = User.find_by(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @users = User.all
    @posts = @user.posts
    @bookmarks = Bookmark.where(user_id: @user.id).all
    if @user == current_user
      Post.page(params[:page]).reverse_order
    else
      Post.where(is_draft: false).page(params[:page]).reverse_order
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      flash[:notice] = '更新が完了しました'
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
       @user.destroy
       flash.now[:notice] = 'アカウントを削除しました'
       redirect_to root_path
    end
  end

  def unsubscribe
    @user = current_user
  end


  private

  def user_params
    params.require(:user).permit(:name, :icon_image, :address, :age, :my_favorite, :live_stance, :status)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end