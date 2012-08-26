module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = {size: 50})
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    # 这里是直接使用了 Rails 提供的 image_tag 方法, 用来生成 img 标签
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
