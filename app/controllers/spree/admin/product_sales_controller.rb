module Spree
  module Admin
    class ProductSalesController < ResourceController  

      def create
        variant = Variant.find(params[:variant_id])
        @product_sale = ProductSale.where(:variant_id => params[:variant_id], :store_id => params[:store_id])
        if @product_sale.empty?
          @product_sale = ProductSale.new(sale_params)
          if @product_sale.save
            flash[:success] = flash_message_for(@product_sale, :successfully_created)
          else
            flash[:error] = Spree.t(:could_not_create_product_sale)
          end
        else
          flash[:error] = "Sale is already, please remove existing sale if you want to add the new sale"
        end       
        redirect_back fallback_location: spree.admin_product_sale_url(variant.product)
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
        params.permit(:sale_price, :description, :start_date, :end_date, :variant_id, :store_id)
      end
    end
  end
end
