class ServerConfiguration < ActiveRecord::Migration
  def change
    create_table :server_configuration do |t|
      t.string :key, :null => false
      t.string :value, :null => false
      t.string :new_value #, :default => :null
      t.integer :service, :default => 0
      t.string :template

      t.timestamps
    end
  end
end
