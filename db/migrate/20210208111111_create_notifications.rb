class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications, id: :uuid  do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
