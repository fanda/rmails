class VirtualUser < ActiveRecord::Migration
  def change
    create_table :virtual_users do |t|
      t.string :email
      t.string :password # XXX devise

      t.integer :quota_kb, :default => 10485760 # 10M
      t.integer :quota_messages

      t.references :virtual_domain

      t.timestamps
    end
  end
end
