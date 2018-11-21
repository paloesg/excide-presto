class PagesController < Spree::BaseController
  include HighVoltage::StaticPage
  include Spree::Core::ControllerHelpers::Order
  before_action :set_taxonomies

  layout 'spree/layouts/spree_application'

  def create_request
    @service_request = Spree::ServiceRequest.new
    @service_request.service_name = params[:id].gsub('-', ' ').titleize
    @service_request.spree_user_id = spree_current_user.id
    @service_request.fields = params[:fields] if params[:fields][:text]
    @service_request.save
    create_service_request_image(params[:fields][:image]) if params[:fields][:image]
    redirect_to page_path(params[:id]), notice: 'Thank you for filling out the form. Your response has been recorded.'
  end

  private

  def create_service_request_image(images)
    images = []
    if params[:fields][:image]
      params[:fields][:image].each do |key, image|
        image = @service_request.images.create(attachment: image)
        images << {text: key, image_id: image.id}
      end
      @service_request.fields['image'] = images
      @service_request.save
    end
  end

  def set_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end