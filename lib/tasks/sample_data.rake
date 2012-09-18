namespace :db do

  desc "Fill database with sample data"
  # 这里的 Environment 是 rails 的环境常量
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Example User", email: "example@railstutorial.org",
                       password: "foobar", password_confirmation: "foobar")
  # 不能通过 hash 的方式传入 admin: ture 是因为 Rails 默认开启了 Mass Assign 的保护
  admin.toggle!(:admin)

  99.times do |i|
    name = Faker::Name.name
    email = "example-#{i+1}@railstutorial.org"
    password = "password"
    User.create!(name: name, email: email,
                 password: password, password_confirmation: password)
  end
end

def make_microposts
  users = User.limit(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each do |user|
      user.microposts.create!(content: content)
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  # 让 user follow 这些人
  followed_users.each { |followed| user.follow!(followed) }
  # 让 user 成为 followers 的 followed_user
  followers.each { |follower| follower.follow!(user) }
end