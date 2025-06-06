class Api::V1::ShopTogglesController < ApplicationController
  before_action :set_tab
  before_action :set_shop, only: [:show, :update, :destroy, :restore, :reset]

  def create
    @shop = @tab.toggles.build(toggle_params.merge(type: 'Shop'))
    if @shop.save
      render json: @shop.as_json(include: :link_generator), status: :created
    else
      render_error(@shop.errors.full_messages.join(', '))
    end
  end

  def update
    if @shop.update(toggle_params)
      render json: @shop.as_json(include: :link_generator)
    else
      render_error(@shop.errors.full_messages.join(', '))
    end
  end

  def show
    render json: @shop.as_json(include: :link_generator)
  end

  def destroy
    @shop.soft_delete!
    render_success({}, 'Shop Toggle soft deleted successfully')
  end

  def restore
    @shop.restore!
    render_success(@shop.as_json(include: :link_generator), 'Shop Toggle restored successfully')
  end

  def reset
    @shop.reset_to_default!
    render_success(@shop.as_json(include: :link_generator), 'Shop Toggle reset to default successfully')
  end

  private

  def set_tab
    @tab = Tab.find(params[:tab_id])
  end

  def set_shop
    @shop = @tab.toggles.find_by!(id: params[:id], type: 'Shop')
  end

  def toggle_params
    params.require(:toggle).permit(
      :title, :image_url, :landing_url, :start_date, :end_date,
      regions: [],
      route_info: [:url, :type]
    )
  end
end