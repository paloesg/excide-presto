class PagesController < Spree::BaseController
  include HighVoltage::StaticPage
  include Spree::Core::ControllerHelpers::Order
  layout 'spree/layouts/spree_application'
end