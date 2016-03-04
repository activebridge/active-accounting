class Vendor < Counterparty
  after_create :create_info_record
  belongs_to :customer
  has_many :hours
  has_one  :vendor_info, dependent: :destroy
  has_many :vendor_acts, dependent: :destroy
  has_many :vendor_orders, dependent: :destroy
  has_many :vacations, dependent: :destroy

  before_create { generate_token(:auth_token) }

  delegate :name, to: :customer, prefix: true

  scope :by_missing_hours, lambda  { |date = Date.current.at_beginning_of_month|
    includes(:hours).active.reject do |v|
      v.hours.where(
        'extract(month from month) = ? AND extract(year from month) = ?', date.month, date.year
      ).first
    end
  }

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
    create_vendor_info
  end

  def authenticate!
    generate_token(:auth_token)
    save
    self
  end
end
