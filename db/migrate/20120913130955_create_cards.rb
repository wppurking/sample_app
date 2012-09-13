class CreateCards < ActiveRecord::Migration
  def up
    create_table :cards do |t|
      t.string :title
      t.string :body

      # also can user t.integer :user_id
      # 但我还是使用表名更加直接.
      t.belongs_to :user

      t.timestamps
    end
  end

  def down
    drop_table :cards
  end
end
