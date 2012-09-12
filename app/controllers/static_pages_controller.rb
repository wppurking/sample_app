class StaticPagesController < ApplicationController
  include SessionsHelper


  def home
    @micropost = current_user.microposts.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
  end

  def help
  end

  def about
  end

  def contact
  end

end
