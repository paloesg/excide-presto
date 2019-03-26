module Spree
  module Admin
    class ProductSalesController < ResourceController

      def create
        product = Product.find(params[:product_id])
        @product_sale = ProductSale.where(:variant_id => sale_params[:variant_id], :store_id => sale_params[:store_id])
        if @product_sale.empty?
          @product_sale = ProductSale.new(sale_params)
          if @product_sale.save
            flash[:success] = flash_message_for(@product_sale, :successfully_created)
          else
            flash[:error] = "#{Spree.t('product_sale.errors.unable_to_create')}: #{@product_sale.errors.full_messages.join(', ')}"
          end
        else
          flash[:error] = "There is already an existing sale price set for this store. Please remove it to add a new sale price."
        end
        redirect_back fallback_location: spree.admin_product_sale_url(product)
      end

      def destroy
        product_sale.destroy
        respond_with(@product_sale) do |format|
          format.html { redirect_back fallback_location: spree.admin_product_sale_url(@product_sale.variant.product) }
          format.js
        end
      end

      private

      def product_sale
        @product_sale ||= ProductSale.find(params[:id])
      end

      def sale_params
        params.require(:product_sale).permit(:sale_price, :description, :start_date, :end_date, :variant_id, :store_id)
      end
    end
  end
end
