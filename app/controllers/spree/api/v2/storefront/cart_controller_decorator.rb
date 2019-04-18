Spree::Api::V2::Storefront::CartController.class_eval do
  before_action :ensure_order, except: [:create, :add_item]

  def add_item
    order_params = {
      user: spree_current_user,
      store: spree_current_store,
      currency: current_currency
    }

    return render_error_user_department_company if spree_current_user.company.blank? && spree_current_user.department.blank?
    return render_error_default_currency if current_currency.blank?

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

  def render_error_user_department_company
    render json: { error: 'Status user department and company undefined' }, status: 422
  end

  def render_error_default_currency
    render json: { error: 'Status currency undefined' }, status: 422
  end
end