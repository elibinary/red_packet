class SyncRedBagWorker
  include Sidekiq::Worker

  def perform(user_id, red_bag_id, win_money)
    win_money = BigDecimal.new(win_money)
    user = User.find_by(id: user_id)
    red_bag = RedBag.find_by(id: red_bag_id)
    if user && red_bag
      RedBag.transaction do
        # 悲观锁锁红包余额
        # lock.lock do
        #   red_bag.balance -= win_money
        #   red_bag.save
        # end

        RedBagItem.create(red_bag_id: red_bag_id, user_id: user_id, money: win_money)
      end

      wallet = user.fetch_wallet
      Wallet.obtain_lock(:trade, wallet.id) do
        Wallet.transaction do
          wallet.balance += win_money
          if wallet.save
            params = {
              wallet_id: wallet.id,
              money: win_money,
              description: "red_bag_id: #{red_bag_id}"
            }
            WalletFlow.create(params)
          end
        end
      end
    end
  end
end
