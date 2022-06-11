class CreateFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :filters do |t|
      t.string :attribute
      t.string :comparison_type
      t.string :comparison_operator
      t.string :compare_string
      t.date :compare_date
      t.time :compare_time
      t.datetime :compare_datetime
      t.daterange :compare_daterange
      t.interval :compare_interval
      t.string :compare_string_array
      t.bigint :compare_number
      t.bigint :compare_number_array

      t.timestamps
    end

    create_join_table :filters, :groups do |t|
      t.index :group_id
      t.index :filter_id

      t.timestamps
    end

    remove_column :groups, :all_tags, :string, array: true
    remove_column :groups, :any_tags, :string, array: true
    remove_column :groups, :author_ids, :bigint, array: true
    remove_column :groups, :content, :string
    remove_column :groups, :created, :datetime
    remove_column :groups, :created_ago, :interval
    remove_column :groups, :created_range, :daterange
    remove_column :groups, :limit, :integer
    remove_column :groups, :updated, :datetime
    remove_column :groups, :updated_ago, :interval
    remove_column :groups, :updated_range, :daterange
  end
end
