class Task < ApplicationRecord
  validates :name, presence: true
  scope :enabled, -> { where(deleted_at: nil) }
  def soft_delete!
    self.deleted_at = Time.now
    save!
  end
end
