class VirtualDomain < ActiveRecord::Base

  has_many :virtual_users
  has_many :virtual_aliases
  has_and_belongs_to_many :admin_users, :join_table => :users_domains

  attr_accessible :name

  validates :name,
    :presence   => true, :uniqueness => true,
    :format     => { :with => /\A(?:[-a-z0-9]+\.)+[a-z]{2,}\Z/i }

  default_scope order('id DESC').includes([:virtual_users, :virtual_aliases])

end
