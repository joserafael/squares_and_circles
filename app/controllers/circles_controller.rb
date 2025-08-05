class CirclesController < ApplicationController
  def index
    @circles = Circle.search(params[:center_x], params[:center_y], params[:radius], params[:frame_id])
    render json: @circles
  end

  def show
    @circle = Circle.find(params[:id])
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
    @circle = Circle.find(params[:id])

    if @circle.update(circle_params)
      render json: @circle
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  def destroy
    @circle = Circle.find(params[:id])
    @circle.destroy
    render json: { message: "Circle deleted successfully" }, status: :ok
  end
  

  private

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
