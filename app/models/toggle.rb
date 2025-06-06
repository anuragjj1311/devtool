class Toggle < ApplicationRecord
  belongs_to :tab
  
  has_one :link_generator, as: :linkable, dependent: :destroy
  accepts_nested_attributes_for :link_generator, allow_destroy: true
  
  # your existing validations...
  validates :link_generator, presence: true
  validates :title, presence: true
  validates :start_date, :end_date, presence: true
  validates :type, presence: true, inclusion: { in: %w[Shop Category] }
  validate :end_date_after_start_date

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :current, -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def restore!
    update!(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end

  def reset_to_default!
    update!(
      title: default_title,
      image_url: default_image_url,
      landing_url: default_landing_url
    )
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, 'must be after start date') if end_date < start_date
  end

  def default_title
    'Default Toggle'
  end

  def default_image_url
    nil
  end

  def default_landing_url
    nil
  end
end