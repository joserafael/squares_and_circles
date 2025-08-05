class FramesController < ApplicationController
  before_action :set_frame, only: [ :show, :update, :destroy ]

  def index
    @frames = Frame.all.includes(:circles)
    render json: @frames.to_json(include: :circles)
  end

  def show
    render json: @frame.to_json(include: :circles)
  end

  def create
    @frame = Frame.new(frame_params)

    if @frame.save
      render json: @frame, status: :created
    else
      render json: @frame.errors, status: :unprocessable_content
    end
  end

  def update
    if @frame.update(frame_params)
      render json: @frame
    else
      render json: @frame.errors, status: :unprocessable_content
    end
  end

  def destroy
    @frame.destroy
    render json: { message: "Frame deleted successfully" }, status: :ok
  end

  private

  def set_frame
    @frame = Frame.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Frame not found" }, status: :not_found
  end

  def frame_params
    params.require(:frame).permit(:center_x, :center_y, :width, :height, circles_attributes: [ :center_x, :center_y, :diameter ])
  end
end
