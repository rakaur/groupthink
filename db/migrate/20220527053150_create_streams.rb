class CreateStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :streams do |t|
      t.string :all_tags, array: true
      t.string :any_tags, array: true

      t.bigint :author_ids, array: true

      t.string :content

      t.datetime :created
      t.interval :created_ago
      t.daterange :created_range

      t.integer :limit

      t.datetime :updated
      t.interval :updated_ago
      t.daterange :updated_range

      t.timestamps
    end
  end
end
