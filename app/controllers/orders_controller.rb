class OrdersController < ApplicationController
  protect_from_forgery
   skip_before_action :verify_authenticity_token, if: :json_request?
   respond_to :json, :html
   before_action :authenticate_user!

   def index
     @user = current_user
     if user_signed_in? && @user.admin?
       @orders = Order.all.includes(:user, :product).to_json(:include => [{product: {only: %i(name image_url)}}, {:user => {:only => :email}}])
      respond_with @orders
     elsif user_signed_in?
       @orders = @user.orders.eager_load(:product).to_json(:include => [{product: {only: %i(name image_url)}}, {:user => {:only => :email}}])
       respond_with @orders
     else
       redirect_to main_app.root_url, alert: "You are not logged in"
     end
   end

   def show
     @order = Order.friendly.find(params[:id]).to_json(include: [{product: {only: %i(name image_url)}}, {:user => {:only => :email}}])
     respond_with @order
   end

   def new
   end

   def create
     @order = current_user
     @order = Order.create(order_params)
     respond_with @order
   end

   def destroy
     respond_with Order.destroy(params[:id])
   end

   protected

   def json_request?
     request.format.json?
   end

   private

   def order_params
     params.require(:order).permit(:product_id, :user_id, :total ,:product_image_url,:email)
   end
end
