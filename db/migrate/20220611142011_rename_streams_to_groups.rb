class RenameStreamsToGroups < ActiveRecord::Migration[7.0]
  def change
    rename_table :streams, :groups
    rename_table :streams_users, :groups_users
    rename_column :groups_users, :stream_id, :group_id
  end
end
