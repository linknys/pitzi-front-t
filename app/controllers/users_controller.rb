class UsersController < ApplicationController
  require 'rest_client'

  API_BASE_URL = "http://localhost:3000/api/v1"

  def index
    uri = "#{API_BASE_URL}/users.json"
    rest_resource = RestClient::Resource.new(uri)
    users = rest_resource.get 
    @users = JSON.parse(users, :symbolize_names => true)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.valid?
        uri = "#{API_BASE_URL}/users"
        payload = params.to_json
        rest_resource = RestClient::Resource.new(uri)
        begin
          resp = rest_resource.post payload , :content_type => "application/json"
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        rescue Exception => e
          logger.debug resp
          @user.errors.add(:fail, e)
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    uri = "#{API_BASE_URL}/users/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.delete
      flash[:notice] = "User Deleted successfully"
    rescue Exception => e
      flash[:error] = "User Failed to Delete"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :cpf)
  end
end
