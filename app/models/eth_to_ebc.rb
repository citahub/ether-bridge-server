class EthToEbc < ApplicationRecord
  enum status: {
    started: 0,
    pending: 10,
    completed: 20,
    failed: 30
  }

  validates :eth_tx_hash, presence: true, uniqueness: true

  before_save :update_status

  private

  def update_status
    self.status_updated_at = Time.now if status_changed?
  end
end
