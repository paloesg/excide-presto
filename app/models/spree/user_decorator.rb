Spree::User.class_eval do
  belongs_to  :company
  belongs_to  :department

  validates_presence_of :company, :department, if: :approved?
  validates_presence_of :email

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def password_required?
    confirmed_at? ? super : false
  end

  def send_new_password_instructions(from_address)
    token = set_reset_password_token
    send_new_password_instructions_notification(from_address, token)

    token
  end

  def send_new_password_instructions_notification(from_address, token)
    UserMailer.new_password_instructions(from_address, self, token, {}).deliver_later
  end

  def full_name
    first_name + ' ' + last_name
  end
end