# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
	before do
		@user = User.new(name: "Example User", email: "user@example.com",
		 password: "foobar", password_confirmation: "foobar")
	end

	subject { @user }

	# What is respond_to
	# > A method to determine if an object responds to a message (e.g., a method call).

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	#  这个是 Model 在添加了 has_secure_password 方法以后自动添加的
	it { should respond_to(:authenticate) }

	# be_valid 是一个 Magic, 本来的代码为 @user.valid? 然后借用 rsepc 的代码 @user.should be_valid ,
	# be_xxx 也就是调用了 @user.xxx? 方法, 注意 ?

	# 这里是因为 @user.name 不为空, 所以这里的检查必须是合法的
	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = " " }
		# 因为再 before 里面将 @user.name 设置成了 空,所以检查应该是不合法的
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			# @user.dup 复制了一个 attr 一模一样的 @user 对象
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			# 调用这个对象 save 方法, 应该返回的是 false, 并且 valid? 返回的也是 false
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn`t match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirm is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "return value of authenticaate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "with a password that`s too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should_not be_valid }
	end
end
