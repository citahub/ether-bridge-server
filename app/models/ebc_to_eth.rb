class EbcToEth < ApplicationRecord
  enum status: {
    started: 0,
    pending: 10,
    completed: 20,
    error_status: 30
  }

  before_save :update_status

  private

  def update_status
    self.status_updated_at = Time.now if status_changed?
  end
end
