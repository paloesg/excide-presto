Spree::FrontendHelper.class_eval do
  def checkout_progress(numbers: false)
    states = @order.checkout_steps
    items = states.each_with_index.map do |state, i|
      #remove unused tab in checkout page
      next if state == 'delivery' || state == 'rejected' || state == 'complete'
      text = Spree.t("order_state.#{state}").titleize
      text.prepend("#{i.succ}. ") if numbers

      css_classes = ['nav-item']
      current_index = states.index(@order.state)
      state_index = states.index(state)

      if state_index < current_index
        css_classes << 'completed'
        text = link_to text, checkout_state_path(state), class: 'nav-link'
      end

      css_classes << 'next' if state_index == current_index + 1
      css_classes << 'active' if state == @order.state
      css_classes << 'first' if state_index == 0
      css_classes << 'last' if state_index == states.length - 1

      if state_index < current_index
        content_tag('li', text, class: css_classes.join(' '))
      else
        content_tag('li', content_tag('a', text, class: "nav-link #{'active text-white' if state == @order.state}"), class: css_classes.join(' '))
      end
    end
    content_tag('ul', raw(items.join("\n")), class: 'progress-steps nav nav-pills nav-justified flex-column flex-md-row', id: "checkout-step-#{@order.state}")
  end


  def spree_breadcrumbs(taxon, separator = '&nbsp;')
    return '' if current_page?('/') || taxon.nil?
    separator = raw(separator)
    crumbs = [content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:home), itemprop: 'name'), spree.root_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')]
    if taxon
      crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:products), itemprop: 'name'), spree.products_path, itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, content_tag(:span, link_to(content_tag(:span, ancestor.name, itemprop: 'name'), seo_url(ancestor), itemprop: 'url') + separator, itemprop: 'item'), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement') } unless taxon.ancestors.empty?
      crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, taxon.name, itemprop: 'name'), seo_url(taxon), itemprop: 'url'), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
    else
      crumbs << content_tag(:li, content_tag(:span, Spree.t(:products), itemprop: 'item'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
    end
    crumb_list = content_tag(:ol, raw(crumbs.flatten.map(&:mb_chars).join), class: 'breadcrumb hero-breadcrumbs', itemscope: 'itemscope', itemtype: 'https://schema.org/BreadcrumbList')
    content_tag(:nav, crumb_list, id: 'breadcrumbs', class: '')
  end

  def taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.leaf?
    taxons = root_taxon.children.map do |taxon|
      css_class = current_taxon && current_taxon.self_and_ancestors.include?(taxon) ? 'list-group-item active' : 'list-group-item'
      sub_taxon_arrow = '<i class="glyphicon glyphicon-triangle-right pull-right"></i>' if taxon.children.length != 0
      sub_taxons = safe_join(taxon.children.map { |t| '<li class="col-md-6">' + link_to(t.name, seo_url(t)) + '</li>' })
      link_to seo_url(taxon), class: css_class, 'data-toggle': "#{'sub-categories' if taxon.children.length != 0}", 'data-content': sub_taxons, title: taxon.name do
        "#{taxon.name} #{sub_taxon_arrow}".html_safe
      end
    end
    services = Spree::Taxonomy.find_by_name('Services').root.children.all()
    if services.present?
      static_pages = services.map do |service|
        css_class = current_taxon && current_taxon.self_and_ancestors.include?(service) ? 'list-group-item active' : 'list-group-item'
        sub_taxon_arrow = '<i class="glyphicon glyphicon-triangle-right pull-right"></i>' if service.children.length != 0
        sub_taxons = safe_join(service.children.map { |t| '<li class="col-md-6">' + link_to(t.name, seo_url(t)) + '</li>' })
        link_to seo_url(service), class: css_class, 'data-toggle': "#{'sub-categories' if service.children.length != 0}", 'data-content': sub_taxons, title: service.name do
          "#{service.name} #{sub_taxon_arrow}".html_safe
        end
      end
      safe_join(taxons + static_pages, "\n")
    else
      safe_join(taxons, "\n")
    end
  end

  def link_to_cart(text = nil)
    text = text ? h(text) : Spree.t('cart')
    css_class = nil

    if simple_current_order.nil? || simple_current_order.item_count.zero?
      text = "<span class='glyphicon glyphicon-shopping-cart'></span> #{text}"
      css_class = 'empty'
    else
      text = "<span class='glyphicon glyphicon-shopping-cart'></span> #{text} <span class='badge badge-presto'>#{simple_current_order.item_count}</span>"
      css_class = 'full'
    end

    link_to text.html_safe, spree.cart_path, class: "cart-info #{css_class}", onclick: "Turbolinks.clearCache();"
  end

  def sort_by
    @sort_value = [ {name: 'Price: Low to High', sort: 'price_asc'}, {name: 'Price: High to Low', sort: 'price_desc'}, {name: 'Name: A - Z', sort: 'name_asc'}, {name: 'Name: Z - A', sort: 'name_desc'} ]
    select_tag 'sort-by', options_for_select(@sort_value.collect{ |s| [s[:name], "?sort=#{s[:sort]}" ] }, "?sort=#{params[:sort]}"), class: 'form-control sort-by', include_blank: 'Choose one...'
  end

  def quantity_order(variant_id)
    item_order = current_order.line_items.find_by(variant_id: variant_id) if current_order.present?
    return item_order ? item_order.quantity : 0
  end
end