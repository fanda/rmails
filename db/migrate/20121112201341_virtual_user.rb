class VirtualUser < ActiveRecord::Migration
  def change
    create_table :virtual_users do |t|
      t.string :name

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      ## Encryptable
      t.string :password_salt

      ## Rememberable
      t.datetime :remember_created_at

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.integer :quota_kb, :default => 10485760 # 10M
      t.integer :quota_messages, :default => 0

      t.references :virtual_domain
      t.timestamps
    end
  end
end
