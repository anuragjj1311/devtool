class Api::V1::CategoryTogglesController < ApplicationController
  before_action :set_tab
  before_action :set_category, only: [:show, :update, :destroy, :restore, :reset]

  def create
    @category = @tab.toggles.build(toggle_params.merge(type: 'Category'))
    if @category.save
      render json: @category.as_json(include: :link_generator), status: :created
    else
      render_error(@category.errors.full_messages.join(', '))
    end
  end

  def update
    if @category.update(toggle_params)
      render json: @category.as_json(include: :link_generator)
    else
      render_error(@category.errors.full_messages.join(', '))
    end
  end

  def show
    render json: @category.as_json(include: :link_generator)
  end

  def destroy
    @category.soft_delete!
    render_success({}, 'Category Toggle soft deleted successfully')
  end

  def restore
    @category.restore!
    render_success(@category.as_json(include: :link_generator), 'Category Toggle restored successfully')
  end

  def reset
    @category.reset_to_default!
    render_success(@category.as_json(include: :link_generator), 'Category Toggle reset to default successfully')
  end

  private

  def set_tab
    @tab = Tab.find(params[:tab_id])
  end

  def set_category
    @category = @tab.toggles.find_by!(id: params[:id], type: 'Category')
  end

  def toggle_params
    params.require(:toggle).permit(
      :title, :image_url, :landing_url, :start_date, :end_date,
      regions: [],
      route_info: [:url, :type]
    )
  end
end