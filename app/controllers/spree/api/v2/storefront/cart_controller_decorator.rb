Spree::Api::V2::Storefront::CartController.class_eval do
  before_action :ensure_order, except: [:create, :add_item]

  def add_item
    order_params = {
      user: spree_current_user,
      store: spree_current_store,
      currency: current_currency
    }

    order   = spree_current_order if spree_current_order.present?
    order ||= create_service.call(order_params).value

    variant = Spree::Variant.find(params[:variant_id])

    spree_authorize! :update, spree_current_order, order_token
    spree_authorize! :show, variant

    result = add_item_service.call(
      order: spree_current_order,
      variant: variant,
      quantity: params[:quantity],
      options: params[:options]
    )

  render_order(result)
  end
end