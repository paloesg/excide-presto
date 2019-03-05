module Spree
  class ServiceIcon < Asset
    include Rails.application.config.use_paperclip ? Image::Configuration::Paperclip : Image::Configuration::ActiveStorage
  end
end