module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    # 为了让 Controller 与 View 能够通过类似 current_user 获取到当前用户,
    # 所以需要添加这样一个方法, 但还需要考虑用户在访问了别的页面的时候是否能够获取
    # 正常的当前用户, 所以还需要通过 cookie 中的 remember_token 来进行判断
    # 也就是这里利用了 ActiveRecord 的动态方法,  find_by_[remember_token]
    # 来通过 Token 查询
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

end
