class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user`s show page.
      sign_in user
      redirect_back_or user
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = "Invalid email/password combination"
      # 这里使用的是 render, 直接在此链接重新绘制一次 new 页面的内容,
      # 我想这里使用 redirect_to 与 render 没什么关系吧, 不过为了与
      # 类似其他 post 请求一致, 所以 post 以后的值都是 render 到上一个页面,
      render "new"
      # 而由于这里的 :error 信息是记录在 flash 中的, flash 是将信息将一直
      # 保留到下一次新的请求中, 而这里使用的是 render, 所需需要手动将其设置成
      # 仅仅保存在这一次的 request 中
    end
  end

  def destory
    sign_out
    redirect_to root_url
  end

end
