# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

class User < ActiveRecord::Base
  # 这个是 Rails 提供的可暴露外更新使用的字段, 与 ruby 本身提供的 attr_accessor/ att_reader/ attr_writer 有区别
  attr_accessible :name, :email, :password, :password_confirmation
  # 使用 has_secure_password 需要有如下的要求
  # 1. schemal 文件中需要拥有 password_digest , 用来存放加密后的密码
  # 2. Gemfile 需要添加  bcrypt-ruby, ~> 3.0.0 的依赖
  # 3. 需要拥有 :password, :password_confirmation 两个可访问的 attribute
  # 4. 会自动引入 ActiveModel::SecurePassword 模块, 并且添加上 :authenticate (方法)
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true


  # ------------------------ Private
  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
