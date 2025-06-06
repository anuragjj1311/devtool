class Api::V1::TogglesController < ApplicationController
  before_action :set_tab
  before_action :set_toggle, only: [:show, :update, :destroy, :restore, :reset]

  def index
    @toggles = @tab.toggles.includes(:link_generator)
    @toggles = @toggles.active if params[:current] == 'true'

    render json: @toggles.as_json(include: :link_generator)
  end

  def show
    render json: @toggle.as_json(include: :link_generator)
  end

  def create
    @toggle = @tab.toggles.build(toggle_params)
    
    if @toggle.save
      render json: @toggle.as_json(include: :link_generator), status: :created
    else
      render_error(@toggle.errors.full_messages.join(', '))
    end
  end

  def update    
    if @toggle.update(toggle_params)
      render json: @toggle.as_json(include: :link_generator)
    else
      render_error(@toggle.errors.full_messages.join(', '))
    end
  end

  def destroy
    @toggle.soft_delete!
    render_success({}, 'Toggle soft deleted successfully')
  end

  def restore
    @toggle.restore!
    render_success(@toggle.as_json(include: :link_generator), 'Toggle restored successfully')
  end

  def reset
    @toggle.reset_to_default!
    render_success(@toggle.as_json(include: :link_generator), 'Toggle reset to default successfully')
  end

  private

  def set_tab
    @tab = Tab.find(params[:tab_id])
  end

  def set_toggle
    @toggle = @tab.toggles.find(params[:id])
  end

  def toggle_params
    params.require(:toggle).permit(
      :title, :type, :image_url, :landing_url, :start_date, :end_date,
      regions: [],
      link_generator_attributes: [:type, :url, :_destroy, :id]
    )
  end
  
  def link_generator_params
    params.require(:toggle).require(:link_generator_attributes).permit(:type, :url)
  end
end