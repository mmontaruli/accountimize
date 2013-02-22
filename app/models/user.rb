class User < ActiveRecord::Base
  belongs_to :client
  has_many :messages, :dependent => :destroy
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  #validates_uniqueness_of :email
  validate :vendor_email_is_unique
  validate :email_under_same_account_must_be_unique
  validates_format_of :password, :with => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,40}$/,:on => :create, :message => "should be between 8 and 40 characeters long and should have at least one number and upper case letter"
  validates_format_of :email, :with => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :on => :create

  def vendor_email_is_unique
    vendor_email_exists(email).each do |user|
      if user.id != self.id and self.client.is_account_master
        errors.add(:email, "already taken")
      end
      # if user.id != self.id
      #   return true
      # end
    end
    # if vendor_email_exists(email).id != self.id and self.client.is_account_master == true
    # #if vendor_email_exists(email) and self.client.is_account_master == true
    #   errors.add(:email, "already taken")
    # end
  end

  def email_under_same_account_must_be_unique
    user_exists = User.find_by_email(email)
    if user_exists and user_exists.client.account.id == self.client.account.id and user_exists.id != self.id
      errors.add(:email, "already taken")
    end
  end

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

  def self.authenticate(email, password, subdomain)
    #user = find_by_email(email)
    account = Account.find_by_subdomain(subdomain)
    client_id = find_client_by_email_and_account(email, account)
    user = User.find(:first, :conditions => {:email => email, :client_id => client_id})
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

  private
  def vendor_email_exists(email)
    a = []
    users_with_email = User.find(:all, :conditions => {:email => email})
    users_with_email.each do |user|
      if user.client.is_account_master == true
        #return true
        # a.push("true")
        # return user
        a.push(user)
      end
    end
    return a
    # if a.grep(/true/).length > 0
    #   return true
    # end
  end

  def self.find_client_by_email_and_account(email, account)
    users = User.find(:all, :conditions => {:email => email})
    clients = account.clients
    users.each do |user|
      clients.each do |client|
        if user.client_id == client.id
          return client.id
        end
      end
    end
  end


end
