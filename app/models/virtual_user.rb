class VirtualUser < ActiveRecord::Base

  devise :database_authenticatable, :encryptable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptor => :dovecot_ssha512, :stretches => 1

  belongs_to :virtual_domain

  attr_accessible :name, :email, :password, :password_confirmation

  attr_accessor :password_confirmation

  before_validation :repair_email_format

  validates :email,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  #validates :password,
  #  :presence   => true

  validates :quota_kb,
    :numericality => true
  validates :quota_messages,
    :numericality => true


  def change_data(params)
    success = if not params[:password].blank?
      update_with_password(params)
    else
      params.delete(:password)
      update_without_password(params)
    end
    return success
  end

  def self.drop_domain_from_email_each(users)
    users.each do |user|
      user.email.sub!(/@.*/, '')
    end
  end

  def repair_email_format
    if self.email !~ /@.*$/
      self.email += "@#{self.virtual_domain.name}"
    end
    true
  end

end
