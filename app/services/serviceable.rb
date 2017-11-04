module Serviceable
  extend ActiveSupport::Concern

  def logger
    Rails.logger
  end

  module ClassMethods
    def call(*args)
      new(*args).call
    end
  end
end
