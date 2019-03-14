Spree::Admin::StoresController.class_eval do
  before_action :set_companies

  def new
  end

  def edit
  end

  private
  def set_companies
    @companies = Spree::Company.all
  end

end