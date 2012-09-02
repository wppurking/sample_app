class CreateMicroposts < ActiveRecord::Migration
  def up
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end

  def down
    drop_table :microposts
  end
end
