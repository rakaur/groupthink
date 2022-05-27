class CreateStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :streams do |t|
      t.string :filters

      t.timestamps
    end
  end
end
