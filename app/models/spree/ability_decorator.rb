Spree::Ability.class_eval do
  def initialize(user)
    clear_aliased_actions

    # override cancan default aliasing (we don't want to differentiate between read and index)
    alias_action :delete, to: :destroy
    alias_action :edit, to: :update
    alias_action :new, to: :create
    alias_action :new_action, to: :create
    alias_action :show, to: :read
    alias_action :index, :read, to: :display
    alias_action :create, :update, :destroy, to: :modify

    user ||= Spree.user_class.new

    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
      can :manage, :all
    elsif user.has_spree_role?('manager')
      can :manage, Spree::Order
      can [:read, :update, :destroy], Spree.user_class, id: user.id
    elsif user.has_spree_role?('finance')
      can :manage, Spree::Order
    elsif user.has_spree_role?('superadmin')
      can :manage, :all
    else
      can :display, Spree::Country
      can :display, Spree::OptionType
      can :display, Spree::OptionValue
      can :create, Spree::Order
      can :read, Spree::Order do |order, token|
        order.user == user || order.guest_token && token == order.guest_token
      end
      can :update, Spree::Order do |order, token|
        order.user == user && order.rejected? || !order.completed? && (order.user == user || order.guest_token && token == order.guest_token) || order.completed? && order.user == user
      end
      can :display, Spree::CreditCard, user_id: user.id
      can :display, Spree::Product
      can :display, Spree::ProductProperty
      can :display, Spree::Property
      can :create, Spree.user_class
      can [:read, :update, :destroy], Spree.user_class, id: user.id
      can :display, Spree::State
      can :display, Spree::Taxon
      can :display, Spree::Taxonomy
      can :display, Spree::Variant
      can :display, Spree::Zone
    end
  end
end