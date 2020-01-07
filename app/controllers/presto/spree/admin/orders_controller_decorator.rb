module Presto
  module Spree
    module Admin
      module OrdersController
        # Override index method of spree/backend/app/controllers/spree/admin/orders_controller.rb
        def index
          params[:q] ||= {}
          params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
          @show_only_completed = params[:q][:completed_at_not_null] == '1'
          params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
          params[:q][:completed_at_not_null] = '' unless @show_only_completed

          # As date params are deleted if @show_only_completed, store
          # the original date so we can restore them into the params
          # after the search
          created_at_gt = params[:q][:created_at_gt]
          created_at_lt = params[:q][:created_at_lt]

          params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == '0'

          if params[:q][:created_at_gt].present?
            params[:q][:created_at_gt] = begin Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue StandardError '' end
          end

          if params[:q][:created_at_lt].present?
            params[:q][:created_at_lt] = begin Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue StandardError '' end
          end

          if @show_only_completed
            params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
            params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
          end

          # Get completed orders from search
          @search = Spree::Order.where(state: 'complete').preload(:user).accessible_by(current_ability, :index).ransack(params[:q])

          # lazy loading other models here (via includes) may result in an invalid query
          # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
          # see https://github.com/spree/spree/pull/3919
          @orders = @search.result(distinct: true).page(params[:page]).per(params[:per_page] || Spree::Config[:admin_orders_per_page])

          # Restore dates
          params[:q][:created_at_gt] = created_at_gt
          params[:q][:created_at_lt] = created_at_lt
        end

        def resend
          Spree::OrderMailer.confirm_email(@order.id, true).deliver_later
          confirm_email_to_managers
          flash[:success] = Spree.t(:order_email_resent)

          redirect_back fallback_location: spree.edit_admin_order_url(@order)
        end

        private
        def confirm_email_to_managers
          managers.each do |manager|
            Spree::OrderMailer.confirm_email(@order, true, manager).deliver_later
          end
        end

        def managers
          Spree::Role.get_manager_by_department(@order.user)
        end
      end
    end
  end
end
