class CreateBroadcasts < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcasts do |t|
      t.references :user
      t.integer :status, default: 0
      t.string :stop_uid
      t.timestamps null: false
    end

    add_index :broadcasts, :status
    add_index :broadcasts, :stop_uid
  end
end
