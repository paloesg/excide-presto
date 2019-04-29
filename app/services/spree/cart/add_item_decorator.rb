Spree::Cart::AddItem.class_eval do
  prepend Spree::ServiceModule::Base

  def call(order:, variant:, quantity: nil, options: {})
    ApplicationRecord.transaction do
      run :add_to_line_item
      run Spree::Dependencies.cart_recalculate_service.constantize
    end
    check_duplicate_line_items(order, variant)
  end

  private

  def add_to_line_item(order:, variant:, quantity: nil, options: {})
    options ||= {}
    quantity ||= 1

    line_item = Spree::Dependencies.line_item_by_variant_finder.constantize.new.execute(order: order, variant: variant, options: options)

    line_item_created = line_item.nil?
    if line_item.nil?
      opts = ::Spree::PermittedAttributes.line_item_attributes.flatten.each_with_object({}) do |attribute, result|
        result[attribute] = options[attribute]
      end.merge(currency: order.currency).delete_if { |_key, value| value.nil? }

      line_item = order.line_items.new(quantity: quantity,
                                        variant: variant,
                                        options: opts)
    else
      line_item.quantity += quantity.to_i
    end

    line_item_quantity = line_item&.quantity&.to_i || 0
    line_item_price = (line_item&.price || variant.product.price) * quantity

    #return error when budget is exceed
    line_item.errors.add(:base, Spree.t('order.budget_exceeded')) if exceed_budget?(order, line_item_price)
    return failure(line_item) if exceed_budget?(order, line_item_price)

    line_item.target_shipment = options[:shipment] if options.key? :shipment
    return failure(line_item) unless line_item.save
    ::Spree::TaxRate.adjust(order, [line_item.reload]) if line_item_created

    #remove item if quantity is 0
    line_item.destroy! if line_item.quantity == 0
    success(order: order, line_item: line_item, line_item_created: line_item_created, options: options)

  end

  def exceed_budget?(order, line_item_price)
    department = order.user&.department

    if department&.budget.nil? || (department&.temp_remaining_budget(order) - line_item_price) < 0
      return true
    else
      return false
    end
  end

  # Check duplicate line items, if line items created with the same variants into order
  # delete other duplicate, keep first line item and update the quantity
  def check_duplicate_line_items(order, variant)
    current_line_items = Spree::LineItem.where(order_id: order.id, variant_id: variant.id)
    quantity = current_line_items.sum(:quantity)
    if current_line_items.length > 1
      current_line_items.each do |duplicate_line_item|
        duplicate_line_item.destroy! unless duplicate_line_item == current_line_items.first
        duplicate_line_item.update(quantity: quantity) if duplicate_line_item == current_line_items.first
      end
    end
  end
end