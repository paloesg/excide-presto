class Manage::OrdersController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order

  layout 'layouts/manage'

  def index
  end
end
