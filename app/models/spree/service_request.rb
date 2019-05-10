class Spree::ServiceRequest < Spree::Base
  paginates_per 10
  has_many :files, as: :viewable, dependent: :destroy, class_name: 'Spree::ServiceRequestFile'

  enum status: {
    unread: "unread",
    processing: "processing",
    completed: "completed",
    rejected: "rejected"
  }

  if Spree.user_class
    belongs_to :processed_by, class_name: Spree.user_class.to_s, optional: true
  else
    belongs_to :processed_by, optional: true
  end

  def can_processing?
    !processing? && !completed? && !rejected?
  end

  def can_complete?
    processing? && !completed?
  end

  def can_reject?
    !processing? && !completed? && !rejected?
  end

  def updated_by(user)
    update_column(:updated_by, user.id)
  end

  def process_by(user)
    update_column(:processed_by_id, user.id)
  end
end