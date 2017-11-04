class WalletFlow < ApplicationRecord
  extend Enumerize

  belongs_to :wallet

  enumerize :source, in: { red_packet: 1, other: 2 }, default: :red_packet, scope: true

  before_save :ensure_transaction_num

  private

  def ensure_transaction_num
    if self.transaction_num.blank?
      self.transaction_num = Time.now.to_formatted_s(:number) + self.wallet_id.to_s + self.wallet.user_id.to_s
    end
  end
end
