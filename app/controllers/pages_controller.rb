class PagesController < Spree::BaseController
  include HighVoltage::StaticPage
  include Spree::Core::ControllerHelpers::Order
  before_action :set_taxonomies

  layout 'spree/layouts/spree_application'

  private

  def set_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end