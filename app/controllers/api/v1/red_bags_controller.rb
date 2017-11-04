class Api::V1::RedBagsController < Api::BaseController

  before_action :check_input, only: [:create]

  # GET /red_bags
  def index
    res = RedBag.grab_reds(current_user)
    render json: { red_bags: res }
  end

  # POST /red_bags
  def create
    red = RedBag.drop_money(current_user, BigDecimal.new(params[:money]), params[:numbers].to_i)
    unless red
      render_fail('红包发放失败')
      return
    end

    render json: { success: 1, red_code: red.safe_code, word: red.token }
  end

  # GET /red_bags/:id
  def show
    details = RedBag.details_by_code(params[:id])
    unless details
      render_fail('红包不存在')
    end

    render json: details
  end

  # GET /red_bags/grab
  def grab
    unless params[:red_code] && params[:word]
      render_fail('参数错误')
      return
    end
    res = GrabRedBagService.call(current_user, params[:red_code], params[:word])

    if res[:state]
      render json: { success: 1, money: res[:win_money] }
    else
      render_fail(res[:msg])
    end
  end

  private

  def check_input
    pattern = /^[-+]?[0-9]*\.?[0-9]+$/
    unless params[:money].match(pattern) && BigDecimal.new(params[:money]) > 0
      render_fail('无效的金额')
      return
    end

    if params[:numbers].to_i <= 0
      render_fail('请传递有效的人数')
      return
    end
  end
end