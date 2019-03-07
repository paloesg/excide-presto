class Spree::ServiceRequestsController < Spree::StoreController
  before_action :set_taxonomies

  def create
    @service_request = Spree::ServiceRequest.new
    # Save service name capitalise “IT”
    service = Spree::Service.find(params[:service_id])
    @service_request.service_name = service.name
    @service_request.spree_user_id = spree_current_user.id
    @service_request.fields = params[:fields] if params[:fields][:text]
    @service_request.save
    create_service_request_file(params[:fields][:file]) if params[:fields][:file]
    @users = Spree::Role.find_by_name('admin').users
    @users.each do |user|
      NotificationMailer.new_service_request(@service_request, user).deliver_later
    end
    flash.notice = 'Thank you! Your request has been recorded. We will get back to you shortly.'
    redirect_back(fallback_location: root_path)
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
