class CreateStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :streams do |t|
      t.jsonb :content, null: false, default: "{}"

      t.timestamps
    end
  end
end
