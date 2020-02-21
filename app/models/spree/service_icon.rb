module Spree
  class ServiceIcon < Asset
    include Image::Configuration::ActiveStorage
  end
end