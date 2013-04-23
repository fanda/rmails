class VirtualAlias < ActiveRecord::Base

  belongs_to :virtual_domain

  attr_accessible :source, :destination

  validates :source,
    :presence   => true

  validates :destination,
    :presence   => true

end
