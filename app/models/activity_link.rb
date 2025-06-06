class ActivityLink < LinkGenerator
  serialize :url, Hash

  validates :url, presence: true
  validate :url_must_be_hash
  validate :required_hash_keys

  def generate_url
    build_activity_url
  end

  def link_type
    'activity'
  end

  private

  def url_must_be_hash
    errors.add(:url, 'must be a hash') unless url.is_a?(Hash)
  end

  def required_hash_keys
    return unless url.is_a?(Hash)

    required_keys = %w[controller action]
    missing_keys = required_keys - url.keys.map(&:to_s)

    if missing_keys.any?
      errors.add(:url, "must contain keys: #{missing_keys.join(', ')}")
    end
  end

  def build_activity_url
    Rails.application.routes.url_helpers.url_for(url.merge(only_path: true))
  rescue => e
    Rails.logger.error "Failed to build activity URL: #{e.message}"
    '#'
  end
end
