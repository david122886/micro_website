class CreateRecentlyClients < ActiveRecord::Migration
  def change
    create_table :recently_clients do |t|
      t.integer :site_id
      t.integer :client_id
      t.text :content

      t.timestamps
    end
  end
end
