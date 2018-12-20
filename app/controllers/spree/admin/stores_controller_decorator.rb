Spree::Admin::StoresController.class_eval do
  def new
    @companies = Spree::Company.all
  end

  def edit
    @companies = Spree::Company.all
  end
end