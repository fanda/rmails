class CreateAdminUser < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :name
      t.boolean :super, :default => false
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      ## Encryptable
      t.string :password_salt

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Lockable
      t.integer  :failed_attempts, :default => 0 # SET lock strategy :failed_attempts
      t.string   :unlock_token # SET unlock strategy  :both
      t.datetime :locked_at

      t.timestamps
    end
  end
end
