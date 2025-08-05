class CirclesController < ApplicationController
  before_action :set_circle, only: [ :show, :update, :destroy ]

  def index
    @circles = Circle.search(params[:center_x], params[:center_y], params[:radius], params[:frame_id])
    render json: @circles
  end

  def show
    render json: @circle
  end

  def create
    @frame = Frame.find(params[:frame_id])
    @circle = @frame.circles.new(circle_params)

    if @circle.save
      render json: @circle, status: :created
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  def update
    if @circle.update(circle_params)
      render json: @circle
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  def destroy
    @circle.destroy
    render json: { message: "Circle deleted successfully" }, status: :ok
  end

  private

  def set_circle
    @circle = Circle.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Circle not found" }, status: :not_found
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter, :frame_id)
  end
end
