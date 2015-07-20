class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    load_stocks
  end

  def new
    build_stock
  end

  def show
    load_stock
  end

  def create
    build_stock
    save_stock || render(:new)
  end

  def edit
    load_stock
    build_stock
  end

  def update
    load_stock
    build_stock
    save_stock || render(:edit)
  end

  def destroy
    load_stock
    destroy_stock
  end

  private

  def load_stocks
    @stocks ||= stock_scope.order(:name)
  end

  def load_stock
    @stock ||= stock_scope.find(params[:id])
  end

  def build_stock
    @stock ||= stock_scope.build
    @stock.attributes = stock_params
  end

  def save_stock
    success_notice = if @stock.persisted?
                       'Stock was successfully updated'
                     else
                       'Stock was successfully created'
                     end

    redirect_to @stock, notice: success_notice if @stock.save
  end

  def destroy_stock
    @stock.destroy
    redirect_to stocks_path, notice: 'Stock was successfully deleted.'
  end

  def stock_scope
    Stock.all
  end

  def stock_params
    stock_params = params[:stock]
    if stock_params
      stock_params.permit(:name, :level, :unit)
    else
      {}
    end
  end
end
