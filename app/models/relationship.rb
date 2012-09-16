class Relationship < ActiveRecord::Base
  # 让被跟踪者的 id 能够设置, 而跟踪者, 则通过 user 直接关联 relationships
  attr_accessible :followed_id
  # 当通过 Relationship 去获得关联的 User 的时候,
  # relationship.user(self.id=2) =>
  #  User Load (0.3ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = 2 LIMIT 1
  # Relationship 是需要加载 User 表的数据, 但他还需要一个 user_id 来告诉他 Relationship 关联的 User
  # 是哪一个? 默认情况下 Relationship 会通过 belongs_to [:name] 的默认值 Relationships(belongs_to)
  # 表中的 name_id, 如上面那样, WHERE 条件中的 users.id = 2 则来源于 Relationships.user_id.  现在,
  # 我们的表结构有一些变化:
  # id, follower_id, followed_id  => (2, 1, 2) [表示, user.id=1 的用户与 user.id=2 的用户拥有一条关系记录]
  # 所以需要通过 belongs_to 的 foreign_key 来告诉 Relationship , 如果你要寻找 belongs_to 的 name , 需要通过
  # foreign_key 来寻找, 所以有这样一个实验:
  # 同样的 relationship.user ,不同的 foreign_key 配置:
  # belongs_to :user, foreign_key: followe[r]_id
  #  User Load (0.3ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
  # belongs_to :user, foreign_key: followe[d]_id
  #  User Load (0.3ms)  SELECT `users`.* FROM `users` WHERE `users`.`id` = 2 LIMIT 1
  #------------------------------------------
  # FIXED: 一个问题, 如果是 has_one 的话会如何?
  # - 如果是 has_one 那么建立关系的外键不会在 Relationships 表中, 那么会通过 belongs_to [:name], 这 name 表中找外键,
  # - 而不是 Relationships 表中找外键了
  #@belongs_to :user, foreign_key: :follower_id

  # 由于 belongs_to [:name] 中的 name 决定了关联方法的名称, 所以在想使用 relationship.follower 来获取
  # 这个关系的主动跟踪者时, 其已经会通过 Followers 表的 follower_id 去寻找了, 但表名不是想要的, 所以修改
  # 表名, 而表名则由  class_name 来控制, 所以将其修改为 User Model, 即 User 表, 这样通过 relationshi.follower
  # 访问的时候, 会寻找 User 表中的 id 与 Relationships 表中 follower_id 一样的 User.
  belongs_to :follower, class_name: "User"
  # 被跟踪的 User 也是如此建立关系
  belongs_to :followed, class_name: "User"


  # belongs_to :user 影响
  # class_name: User
  # foreign_key: user_id
  # source: ??


  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
