class VirtualDomain < ActiveRecord::Base

  has_many :virtual_users
  has_many :virtual_aliases

end
