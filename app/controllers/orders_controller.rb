class OrdersController < ApplicationController
  require 'rest_client'

  API_BASE_URL = "http://localhost:3000/api/v1"

  def index
    uri = "#{API_BASE_URL}/orders.json"
    rest_resource = RestClient::Resource.new(uri)
    orders = rest_resource.get 
    @orders = JSON.parse(orders, :symbolize_names => true)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    respond_to do |format|
      if @order.valid?
        uri = "#{API_BASE_URL}/orders"
        payload = params.to_json
        rest_resource = RestClient::Resource.new(uri)
        begin
          rest_resource.post payload , :content_type => "application/json"
          format.html { redirect_to @order, notice: 'Order was successfully created.' }
          format.json { render :show, status: :created, location: @order }
        rescue Exception => e
          logger.debug e
          @order.errors.add(:fail, e)
          format.html { render :new }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    uri = "#{API_BASE_URL}/orders/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.delete
      flash[:notice] = "Order Deleted successfully"
    rescue Exception => e
      flash[:error] = "Order Failed to Delete"
    end
    redirect_to orders_path
  end

  private
  def order_params
    params.require(:order).permit(:device_model, :imei, :anual_price, :installments)
  end
end
