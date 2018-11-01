Spree::ProductsController.class_eval do
  def show_modal
    load_product
    render :layout => false
  end
end