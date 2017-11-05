module Serviceable
  extend ActiveSupport::Concern

  module ClassMethods
    def call(*args)
      new(*args).call
    end
  end
end
