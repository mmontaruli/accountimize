class User < ActiveRecord::Base
  belongs_to :client
  has_many :messages, :dependent => :destroy
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :password, :with => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,40}$/,:on => :create, :message => "should be between 8 and 40 characeters long and should have at least one number and upper case letter"
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :on => :create

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
