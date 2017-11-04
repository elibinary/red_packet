class User < ApplicationRecord
  has_one :wallet, dependent: :destroy

  before_save :ensure_user_key
  after_commit :build_wallet, on: :create

  def fetch_wallet
    wallet || build_wallet
  end

  private

  def ensure_user_key
    if self.user_key.blank?
      self.user_key = SecureRandom.uuid.gsub('-', '')
    end
  end

  def build_wallet
    self.create_wallet
  end
end
