Spree::FrontendHelper.class_eval do
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
      link_to(taxon.name, seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
    end
    static_pages = HighVoltage.page_ids.map do |page|
      link_to(page.gsub('-', ' ').titleize , "/services/#{page}", class: 'list-group-item')
    end
    safe_join(taxons + static_pages, "\n")
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

    link_to text.html_safe, spree.cart_path, class: "cart-info #{css_class}"
  end

  def sort_by
    @sort_value = [ {name: 'Brand A - Z', sort: 'brand_asc'}, {name: 'Brand Z - A', sort: 'brand_desc'}, {name: 'Prices Low to high', sort: 'price_asc'}, {name: 'Prices high to low', sort: 'price_desc'}, {name: 'A - Z', sort: 'name_asc'}, {name: 'Z - A', sort: 'name_desc'} ]
    select_tag 'sort-by', options_for_select(@sort_value.collect{ |s| [s[:name], "?sort=#{s[:sort]}" ] }), class: 'form-control sort-by', include_blank: 'Choose one...'
  end
end