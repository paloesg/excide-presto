module Spree
  module Admin
    class ProductSalesController < ResourceController
      before_action :set_product
      before_action :set_variants
      before_action :set_product_sales

      def new
        @product_sale = ProductSale.new
      end

      def create
        @product_sale = ProductSale.new(sale_params)
        if @product_sale.save
          flash[:success] = flash_message_for(@product_sale, :successfully_created)
          redirect_to spree.new_admin_product_product_sale_path(@product)
        else
          render :new
        end
      end

      def destroy
        @sale = Spree::ProductSale.find(params[:id])
        if @sale.destroy
          flash[:success] = Spree.t('notice_messages.product_sale_deleted')
        else
          flash[:error] = Spree.t('notice_messages.product_sale_not_deleted', error: @sale.errors.full_messages.to_sentence)
        end
        respond_with(@sale) do |format|
          format.html { redirect_to spree.new_admin_product_product_sale_path(@product) }
          format.js { render_js_for_destroy }
        end
      end

      private

      def set_product
        @product = Product.friendly.find(params[:product_id])
      end

      def set_variants
        @variants = @product.variants.includes(*variant_stock_includes)
        @variants = [@product.master] if @variants.empty?
      end

      def set_product_sales
        variant_ids = @variants.pluck(:id)
        @product_sales = ProductSale.where(variant_id: variant_ids)
      end

      def variant_stock_includes
        [:images, stock_items: :stock_location, option_values: :option_type]
      end

      def product_sale
        @product_sale ||= ProductSale.find(params[:id])
      end

      def sale_params
        params.require(:product_sale).permit(:sale_price, :description, :start_date, :end_date, :variant_id, :store_id)
      end
    end
  end
end
