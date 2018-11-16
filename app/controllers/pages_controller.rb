class PagesController < Spree::BaseController
  include HighVoltage::StaticPage
  include Spree::Core::ControllerHelpers::Order
  before_action :set_taxonomies

  layout 'spree/layouts/spree_application'

  def create_request
    @service_request = Spree::ServiceRequest.new
    @service_request.service_name = params[:id].gsub('-', ' ').titleize
    @service_request.spree_user_id = spree_current_user.id
    @service_request.fields = params[:fields]
    @service_request.save
  end

  private

  def set_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end