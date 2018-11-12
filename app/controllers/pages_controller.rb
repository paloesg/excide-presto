class PagesController < ApplicationController
  include HighVoltage::StaticPage
  include Spree::Core::ControllerHelpers::Store
end