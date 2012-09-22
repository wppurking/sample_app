class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    @user.save

    respond_to do |format|
      format.html { redirect_to @user }
      # 表示需要返回一串 js 代码, 而且会自动根据 controller/action 去寻找 app/view/controller/action.js.erb
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
