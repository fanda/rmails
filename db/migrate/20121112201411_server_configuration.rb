class ServerConfiguration < ActiveRecord::Migration
  def change
    create_table :server_configuration do |t|
      t.string :key
      t.string :value
      t.integer :service
      t.timestamps
    end
  end
end
