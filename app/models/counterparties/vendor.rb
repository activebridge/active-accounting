class Vendor < Counterparty
  after_create :create_info_record
  belongs_to :customer
  has_many :hours
  has_one  :vendor_info, dependent: :destroy
  has_many :vendor_acts, dependent: :destroy

  before_create { generate_token(:auth_token) }

  delegate :name, to: :customer, prefix: true

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    VendorMailer.password_reset(self).deliver
  end

  def generate_token(column)
    self[column] = SecureRandom.urlsafe_base64
    generate_token if Vendor.exists?(column => self[column])
  end

  def create_info_record
    self.create_vendor_info
  end
end
