class Shop < Toggle
  has_one :link_generator, as: :linkable, dependent: :destroy

  validates :link_generator, presence: true

  accepts_nested_attributes_for :link_generator, allow_destroy: true

  def route_info
    link_generator
  end

  def route_info=(attributes)
    if attributes.is_a?(Hash)
      url_value = attributes[:url] || attributes['url']
      link_type = determine_link_type(url_value)
      attributes[:type] = link_type.classify

      if link_generator.present?
        link_generator.update!(attributes)
      else
        build_link_generator(attributes)
      end
    end
  end

  private

  def determine_link_type(url)
    case url
    when String then 'direct_link'
    when Hash then 'activity_link'
    else raise ArgumentError, 'URL must be either String or Hash'
    end
  end

  def default_title
    'Default Shop Toggle'
  end
end
