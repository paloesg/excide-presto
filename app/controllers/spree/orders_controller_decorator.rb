Spree::OrdersController.class_eval do
  respond_override populate: { html: { success: lambda { redirect_back_or_default(spree.root_path) } } }
end