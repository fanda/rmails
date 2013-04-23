class JoinDomainsUsers < ActiveRecord::Migration
  def change
    create_table :users_domains, :id => false do |t|
      t.references :admin_user, :null => false
      t.references :virtual_domain, :null => false
    end

    add_index :users_domains,
              [:admin_user_id, :virtual_domain_id],
              :unique => true
  end
end
