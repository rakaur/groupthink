class CreateStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :streams do |t|
      t.string :content

      t.timestamps
    end
  end
end
