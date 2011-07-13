class Customer < CouchRest::Model::Base
  use_database CouchServer.default_database
  
  attr_accessor :password, :password_confirmation
  
  property :name
  property :email
  property :address, :cast_as => Address
  property :phone_number
  property :customer_id
  property :notes
  property :restaurant
  property :encrypted_password
  property :salt
  property :remember_token
  
  view_by :customer_id
  view_by :email
  
  set_callback :create, :before, :set_customer_id
  set_callback :save, :before, :encrypt_password
  
  def set_customer_id
    self['customer_id'] = Customer.max_customer_id + 1
  end
  
  def self.max_customer_id
    customer_ids = Customer.all.collect {|customer| customer.customer_id}
    Integer(customer_ids.max)
  end
  
  def self.find_by_session(session)
    Customer.by_customer_id(:key => session).first
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    customer = Customer.by_email(:key => email).first
     return nil if customer.nil?
     return customer if customer.has_password?(submitted_password)
  end

  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}")
    save(false)
  end
  
  private
  
  def encrypt_password 
    unless password.nil?
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
  end
  
  def encrypt(string) 
    secure_hash("#{salt}#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end  
  
end