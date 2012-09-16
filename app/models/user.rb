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

  # 关系 1-N
  has_many :microposts, dependent: :destroy

  # 关系 1-1
  has_one :card

  # 1. 如果写成  has_many :relationships
  # 那么在通过 User.relationships 寻找此 user 的 Relationships 的时候, 会自动映射 user_id 在 Relationships 表中寻找
  # user.relationships =>
  #   Relationship Load (0.3ms)  SELECT `relationships`.* FROM `relationships` WHERE `relationships`.`user_id` = 1
  # 但如果通过 user 寻找 relationships 的外键不是默认的 user_id, 那么则需要告诉 User 说: "你与 Relationships 的关系不再是原来
  # 我们默认好的 user_id 了, 而是特别指定的 foreign_key: follower_id", 那么这个时候的执行 SQL 语句为
  # u.relationships =>
  #   Relationship Load (0.3ms)  SELECT `relationships`.* FROM `relationships` WHERE `relationships`.`follower_id` = 1
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  # 如果关联关系需要经过一个中间表来处理, 那么则需要使用 through 参数来配置, 类似于:
  # "要从 User 找 followed_users 则通过 relationships 表中的 followed 去寻找"
  # 而在 SQL 语句上, 使用的是 INNER JOIN
  # user.followed =>
  #  User Load (0.4ms)  SELECT `users`.* FROM `users`
  # INNER JOIN `relationships` ON `users`.`id` = `relationships`.`followed_id`
  # WHERE `relationships`.`follower_id` = 1
  #has_many :followed, through: :relationships

  # 这里, 是因为需要使用 user.followed_users 而不是 user.followed(s) 来获取这个关系, 所以无法使用 ActiveRecord
  # 通过 :followed_users 默认寻找的 source:followed_user , 需要手动指定 source: :followed(s)
  has_many :followed_users, through: :relationships, source: :followed

  # 不太理解, 为什么在 sample_app 中会需要使用一个 revers_relationships, 直接使用 relationships 也完成了
  # 这个功能啊? 并且 revers_relationships 也没有在其他任何地方使用到
  has_many :followers, through: :relationships
  has_many :revers_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true


  def feed
    Micropost.where("user_id=?", id)
  end

  # 是否跟踪了某一个人
  def following?(other_user)
    #relationships.find("followed_id=?", other_user.id)
    relationships.find_by_followed_id(other_user.id)
  end

  # 跟某一个人
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    # 由于不知道 Relationship 的 id, 只能通过 other_user.id 来获取
    # 所以只能先寻找 Relationship 再摧毁
    relationships.find_by_followed_id(other_user.id).destroy
  end

  # ------------------------ Private
  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
