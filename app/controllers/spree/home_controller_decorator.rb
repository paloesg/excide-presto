Spree::HomeController.class_eval do
  before_action :set_categories

  def set_categories
    @categories = Spree::Taxonomy.find_by_name('Categories').root.children.take(4)
  end
end
