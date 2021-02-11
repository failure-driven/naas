class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites, id: :uuid do |t|
      t.string :url, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    create_table :site_users, id: :uuid do |t|
      t.references :site, index: true, null: false, type: :uuid
      t.references :user, index: true, null: false, type: :uuid
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    create_table :keys, id: :uuid do |t|
      t.references :site, null: false, type: :uuid
      t.string :key, null: false
      t.string :secret, null: false

      t.timestamps
    end
  end
end
