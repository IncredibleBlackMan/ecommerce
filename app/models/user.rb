class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/

  def downcase_email
    self.email = email.delete('').downcase
  end
end
