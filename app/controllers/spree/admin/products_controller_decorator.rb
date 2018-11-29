Spree::Admin::ProductsController.class_eval do

  def sale
    @product = Spree::Product.friendly.find(params[:product_id])
    @variants = @product.variants.includes(*variant_stock_includes)
    @variants = [@product.master] if @variants.empty?
    @variant_ids = @variants.pluck(:id)
    @product_sales = Spree::ProductSale.where(variant_id: @variant_ids)
  end

end