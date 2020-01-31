class Order < ApplicationRecord
    validates :device_model, :imei, :anual_price, presence: true
end
