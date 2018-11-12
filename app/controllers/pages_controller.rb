class PagesController < ApplicationController
  include HighVoltage::StaticPage

  private

  # Override method current_store
  def current_store
  end
end