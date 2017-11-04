class User < ApplicationRecord
  has_one :wallet, dependent: :destroy

  before_save :ensure_user_key


  private

  def ensure_user_key
    if self.user_key.blank?
      self.user_key = SecureRandom.uuid.gsub('-', '')
    end
  end
end
