class Spree::ServiceRequest < Spree::Base
  paginates_per 10
  has_many :files, as: :viewable, dependent: :destroy, class_name: 'Spree::ServiceRequestFile'
  belongs_to :user

  enum status: {
    newest: "newest",
    processing: "processing",
    completed: "completed",
    rejected: "rejected"
  }

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
    update_columns(
      updated_by: user.id
    )
  end

end