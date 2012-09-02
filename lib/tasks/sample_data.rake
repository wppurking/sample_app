namespace :db do
  desc "Fill database with sample data"
  # 这里的 Environment 是 rails 的环境常量
  task populate: :environment do
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

    users = User.limit(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each do |user|
        user.microposts.create!(content: content)
      end
    end
  end
end