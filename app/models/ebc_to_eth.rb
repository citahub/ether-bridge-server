class EbcToEth < ApplicationRecord
  enum status: {
    pending: 0,
    completed: 10,
    error_status: 20
  }

  before_save :update_status

  private

  def update_status
    self.status_updated_at = Time.now if status_changed?
  end
end
