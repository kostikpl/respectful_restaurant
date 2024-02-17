class MenuItemsController < ApplicationController
  def index
    @menu_items = MenuItem.all

    render json: { data: @menu_items.as_json(only: %i[price_cents title]) }
  end
end
