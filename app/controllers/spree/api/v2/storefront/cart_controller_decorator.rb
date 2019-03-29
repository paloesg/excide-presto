Spree::Api::V2::Storefront::CartController.class_eval do
  def add_item
    variant = Spree::Variant.find(params[:variant_id])

    spree_authorize! :update, spree_current_order, order_token
    spree_authorize! :show, variant

    result = add_item_service.call(
      order: spree_current_order,
      variant: variant,
      quantity: params[:quantity],
      options: params[:options]
    )

    line_item = result.value
    # remove line item if quantity = 0
    remove_line_item_service.call(order: spree_current_order, line_item: line_item) if line_item.quantity == 0

    render_order(result)
  end
end