class AdminUser < ActiveRecord::Base

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable,
         :validatable, :lockable

  has_and_belongs_to_many :virtual_domains, :join_table => :users_domains

  attr_accessible :name, :email, :password, :password_confirmation, :virtual_domain_ids

  attr_accessor :password_confirmation

  validates :email,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  #validates :password,
  #  :presence   => true,
  #  :unless     => 'selfpassword.empty?'

  before_create :be_super!, :if => 'AdminUser.first.nil?'

  def be_super!
    self.super = true
  end

  def domains
    vd = self.super == true ? VirtualDomain.all : self.virtual_domains
    vd.each do |domain|
      VirtualUser.drop_domain_from_email_each(domain.virtual_users)
    end
    vd
  end

  def domain(id)
    (self.super == true ? VirtualDomain : self.virtual_domains).find(id)
  end

  def build_domain(params)
    domain = self.virtual_domains.build
    domain[:name] = params[:name]
    domain
  end


  def change_data(params)
    attrs = params.symbolize_keys
    if attrs[:password].blank?
      attrs.delete(:password)
      update_without_password(attrs)
    else
      update_with_password(attrs)
    end
  end

end
