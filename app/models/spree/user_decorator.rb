Spree::User.class_eval do
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def password_required?
    confirmed_at? ? super : false
  end
end