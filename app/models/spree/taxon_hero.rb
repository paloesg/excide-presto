module Spree
  class TaxonHero < Asset
    include Rails.application.config.use_paperclip ? Image::Configuration::Paperclip : Image::Configuration::ActiveStorage
  end
end