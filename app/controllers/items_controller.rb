class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    load_items
  end

  def new
    build_item
  end

  def show
    load_item
  end

  def create
    build_item
    save_item || render(:new)
  end

  def edit
    load_item
    build_item
  end

  def update
    load_item
    build_item
    save_item || render(:edit)
  end

  def destroy
    load_item
    destroy_item
  end

  private

  def load_items
    @items ||= item_scope.order(:name)
  end

  def load_item
    @item ||= item_scope.find(params[:id])
  end

  def build_item
    @item ||= item_scope.build
    @item.attributes = item_params
  end

  def save_item
    success_notice = if @item.persisted?
                       'Item was successfully updated'
                     else
                       'Item was successfully created'
                     end

    redirect_to @item, notice: success_notice if @item.save
  end

  def destroy_item
    @item.destroy
    redirect_to items_path, notice: 'Item was successfully deleted'
  end

  def item_scope
    Item.all
  end

  def item_params
    item_params = params[:item]
    if item_params
      item_params.permit(:name,
                         :price,
                         stock_effects_attributes: [:id, :stock_id, :change])
    else
      {}
    end
  end
end
