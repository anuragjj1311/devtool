class Tab < ApplicationRecord
  has_many :toggles, dependent: :destroy

  validates :title, presence: true
  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  # Use Rails 7 native JSON support - no serialize needed
  # Make sure your migration creates regions as JSON type

  scope :active, -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }
  scope :by_region, ->(region) { 
    # SQLite JSON search - checks if region exists in the JSON array
    where("EXISTS (SELECT 1 FROM JSON_EACH(regions) WHERE JSON_EACH.value = ?)", region)
  }

  private

  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, 'must be after start date') if end_date < start_date
  end
end