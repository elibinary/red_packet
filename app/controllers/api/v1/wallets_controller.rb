class Api::V1::WalletsController < Api::BaseController

  # GET /wallets
  def index
    wallet = current_user.fetch_wallet
    render json: wallet.as_simple_json
  end

end
