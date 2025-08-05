class FramesController < ApplicationController
  def create
    @frame = Frame.new(frame_params)

    if @frame.save
      render json: @frame, status: :created
    else
      render json: @frame.errors, status: :unprocessable_content
    end
  end

  def show
    @frame = Frame.find(params[:id])
    render json: @frame.to_json(include: :circles)
  end

  private

  def frame_params
    params.require(:frame).permit(:center_x, :center_y, :width, :height, circles_attributes: [:center_x, :center_y, :diameter])
  end
end
