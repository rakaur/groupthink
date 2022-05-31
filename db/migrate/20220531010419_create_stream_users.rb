class CreateStreamUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :streams do |t|
      t.index :stream_id
      t.index :user_id

      t.timestamps
    end
  end
end
