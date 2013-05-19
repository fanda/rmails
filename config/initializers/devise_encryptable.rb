require "digest/sha2"
require "base64"

module Devise

  # Declare encryptors length which are used in migrations.
  #ENCRYPTORS_LENGTH = {
  #  :dovecot_ssha512 => 72
  #}

  # Used to define the password encryption algorithm.
  #mattr_accessor :encryptor
  #@@encryptor = nil

  module Encryptable
    module Encryptors
      class DovecotSsha512 < Base
        # Generates a default password digest based on salt, pepper and the
        # incoming password.
        def self.digest(password, stretches, salt, pepper)
          digest = password #[password, salt].flatten.join('')
          stretches.times { digest = Digest::SHA512.digest(digest) }
          '{SHA512}'+ Base64.encode64(digest).chomp # + salt)
        end
        def self.compare(encrypted_password, password, stretches, salt, pepper)
          Devise.secure_compare(encrypted_password, digest(password, stretches, salt, pepper))
        end
        def self.salt(stretches)
          Devise.friendly_token[0,20]
        end
      end
    end
  end
end

#Devise.add_module(:encryptable, :model => './model')
#Devise.add_module( :encryptable)
