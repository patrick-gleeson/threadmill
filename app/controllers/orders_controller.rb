class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    load_orders
  end

  def new
    build_order
  end

  def show
    load_order
  end

  def create
    build_order
    save_order || (render :new)
  end

  def edit
    load_order
    build_order
  end

  def update
    load_order
    build_order
    save_order || (render :edit)
  end

  def destroy
    load_order
    destroy_order
  end

  private

  def load_orders
    @orders ||= order_scope.order(:created_at).page(params[:page])
  end

  def load_order
    @order ||= order_scope.find(params[:id])
  end

  def build_order
    @order ||= order_scope.build
    @order.attributes = order_params
    @order.user ||= current_user
  end

  def save_order
    success_notice = if @order.persisted?
                       'Order was successfully updated'
                     else
                       'Order was successfully created'
                     end

    redirect_to @order, notice: success_notice if @order.save
  end

  def destroy_order
    @order.destroy
    redirect_to orders_path, notice: 'Order was successfully deleted'
  end

  def order_scope
    Order.all
  end

  def order_params
    order_params = params[:order]
    if order_params
      order_params.permit(line_items_attributes: [:id, :item_id, :quantity])
    else
      {}
    end
  end
end
