class AddRememberTokenToUsers < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      t.string :remember_token
    end

    add_index :users, :remember_token
  end

  def down
    remove_columns :users, :remember_token
    remove_index :users, :remember_token
  end
end
