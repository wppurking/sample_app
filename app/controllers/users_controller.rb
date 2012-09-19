class UsersController < ApplicationController
  include SessionsHelper

  # 检查需要登陆
  before_filter :signed_in_user, only: [:edit, :update]
  # 检查需要自己的用户才能修改自己的
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 10)
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  # 这个是通过 user/1/following 访问进来的
  # 这种嵌套访问属于在 routes.rb 中 resources 的 member 使用(如果是集合则 collection)
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    render "show_follow"
  end

  private
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if not current_user?(@user)
  end

  # 判断是否为有管理员权限
  def admin_user
    redirect_to(root_path) if not current_user.admin?
  end
end
