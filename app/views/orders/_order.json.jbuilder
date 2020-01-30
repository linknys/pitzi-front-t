json.extract! order, :id, :device_model, :imei, :anual_price, :installments, :created_at, :updated_at
json.url order_url(order, format: :json)
