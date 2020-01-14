module Presto
  module Spree
    module OrderMailerDecorator
      # Send email to user or manager to confirm they order
      def confirm_email(order, resend = false, manager = nil)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @manager = manager if manager.present?
        subject = (resend ? "[#{::Spree.t(:resend).upcase}] " : '')
        subject += "#{::Spree::Store.current.name} #{::Spree.t('order_mailer.confirm_email.subject')} ##{@order.number}"
        mail(to: @manager.nil? ? @order.email : @manager.email, from: from_address, subject: subject)
      end

      # Send email to user who placed the order with the details of order.
      def order_confirmation(order, resend = false)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @managers = ::Spree::Role.get_manager_by_department(@order.user)
        subject = (resend ? "[#{::Spree.t(:resend).upcase}] " : '')
        subject += "#{::Spree::Store.current.name} | Your order ##{@order.number} is pending approval"

        mail(to: @order.email, from: from_address, subject: subject)
      end

      # Send email to managers for new order that is awaiting approval
      def order_request_approval_manager(order, manager)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @manager = manager
        subject = "#{::Spree::Store.current.name} | Order ##{@order.number} requires your approval"

        mail(to: @manager.email, from: from_address, subject: subject)
      end

      # Send email to user after the order is approved
      def order_approved(order, resend = false)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        subject = (resend ? "[#{::Spree.t(:resend).upcase}] " : '')
        subject += "#{::Spree::Store.current.name} | Your order ##{@order.number} has been approved"

        mail(to: @order.email, from: from_address, subject: subject)
      end

      # Send email to user after the order is rejected
      def order_rejected(order, resend = false)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        subject = (resend ? "[#{::Spree.t(:resend).upcase}] " : '')
        subject += "#{::Spree::Store.current.name} | Your order ##{@order.number} has been rejected"

        mail(to: @order.email, from: from_address, subject: subject)
      end

      # Send email to admin for an order that has been approved by manager
      def order_notify_admin(order, admin)
        @order = order.respond_to?(:id) ? order : ::Spree::Order.find(order)
        @admin = admin
        subject = "#{::Spree::Store.current.name} | An order ##{@order.number} has been received"

        mail(to: admin.email, from: from_address, subject: subject)
      end
    end
  end
end

::Spree::OrderMailer.prepend Presto::Spree::OrderMailerDecorator