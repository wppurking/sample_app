class MicropostsController < ApplicationController
  #TODO 在 Listing 10.28 中, 并没有 include Sess... 但是在我的代码中必须拥有才可以成功, 为什么?
  include SessionsHelper

  before_filter :signed_in_user, only: [:create, :destroy]

  def index
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # 如果创建错误, 不要跳转, 直接内部转向首页
      render 'static_pages/home'
    end
  end

  def destroy
  end

end
