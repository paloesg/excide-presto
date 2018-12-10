class PagesController < Spree::BaseController
  include HighVoltage::StaticPage
  include Spree::Core::ControllerHelpers::Order
  before_action :set_taxonomies

  layout 'spree/layouts/spree_application'

  # Format of naming for text or number fields `fields[text][name of label]`, and for the file fields `fields[file][name of label]`
  # Example `= file_field_tag 'fields[file][Upload office floor plan]', class: 'form-control'`
  def create_request
    @service_request = Spree::ServiceRequest.new
    @service_request.service_name = params[:id].gsub('-', ' ').titleize
    @service_request.spree_user_id = spree_current_user.id
    @service_request.fields = params[:fields] if params[:fields][:text]
    @service_request.save
    create_service_request_file(params[:fields][:file]) if params[:fields][:file]
    @users = Spree::Role.find_by_name('admin').users
    @users.each do |user|
      NotificationMailer.new_service_request(@service_request, user).deliver_later
    end
    redirect_to page_path(params[:id]), notice: 'Thank you for filling out the form. Your response has been recorded.'
  end

  private

  def create_service_request_file(files)
    new_files = []
    files.each do |key, file|
      new_file = @service_request.files.create(attachment: file)
      new_files << {text: key, id: new_file.id}
    end
    @service_request.fields['file'] = new_files
    @service_request.save
  end

  def set_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end