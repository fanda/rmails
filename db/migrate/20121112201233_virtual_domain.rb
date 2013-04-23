class VirtualDomain < ActiveRecord::Migration
  def change
    create_table :virtual_domains do |t|
      t.string :name
      t.timestamps

      t.integer :limit_aliases, :default => 0
      t.integer :limit_users,   :default => 0
    end
  end
end
