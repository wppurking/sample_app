class UsersController < ApplicationController
  include SessionsHelper

  # 检查需要登陆
  before_filter :signed_in_user, only: [:edit, :update]
  # 检查需要自己的用户才能修改自己的
  before_filter :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
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

  private
  def signed_in_user
    #noinspection RubyControlFlowConversionInspection
    if not signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if not correct_user?(@user)
  end
end
