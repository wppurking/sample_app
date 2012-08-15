class AddPaddwordDigestToUsers < ActiveRecord::Migration
  def change
  	# add_paddword_digest_[to_users] 最后面的 to_users 表示了使用哪个 table
    add_column :users, :password_digest, :string
  end
end
