class Spree::ServicesController < Spree::StoreController
  before_action :load_service, only: :show
  before_action :load_taxon
  before_action :set_taxonomies

  def index
    @services = Spree::Taxonomy.find_by_name('Services').root.children.all()
  end

  def show_modal
    load_service
    render :layout => false
  end

  private

  def accurate_title
    if @service
      @service.meta_title.blank? ? @service.name : @service.meta_title
    else
      super
    end
  end

  def load_service
    @service = Spree::Service.find(params[:id])
  end

  def load_taxon
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end

  def redirect_if_legacy_path
    # If an old id or a numeric id was used to find the record,
    # we should do a 301 redirect that uses the current friendly id.
    if params[:id] != @service.friendly_id
      params[:id] = @service.friendly_id
      params.permit!
      redirect_to url_for(params), status: :moved_permanently
    end
  end

  def set_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

end
