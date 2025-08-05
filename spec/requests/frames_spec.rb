require 'rails_helper'

RSpec.describe "Frames", type: :request do
  describe "POST /frames" do
    it "creates a new frame" do
      post "/frames", params: { frame: { center_x: 10, center_y: 10, width: 20, height: 20 } }
      expect(response).to have_http_status(:created)
    end

    it "creates a new frame with circles" do
      post "/frames", params: { frame: { center_x: 10, center_y: 10, width: 20, height: 20, circles_attributes: [{ center_x: 10, center_y: 10, diameter: 5 }] } }
      expect(response).to have_http_status(:created)
      expect(Frame.last.circles.count).to eq(1)
    end

    it "returns unprocessable entity if frame is invalid" do
      post "/frames", params: { frame: { center_x: 10, center_y: 10, width: -20, height: 20 } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /frames" do
    it "returns a list of frames" do
      Frame.create(center_x: 10, center_y: 10, width: 20, height: 20)
      get "/frames"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(1)
    end
  end

  describe "GET /frames/:id" do
    it "returns a frame" do
      frame = Frame.create(center_x: 10, center_y: 10, width: 20, height: 20)
      get "/frames/#{frame.id}"
      expect(response).to have_http_status(:ok)
    end

    it "returns not found if frame does not exist" do
      get "/frames/999"
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Frame not found")
    end
  end

  describe "DELETE /frames/:id" do
    it "deletes a frame" do
      frame = Frame.create(center_x: 10, center_y: 10, width: 20, height: 20)
      delete "/frames/#{frame.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Frame deleted successfully")
      expect(Frame.count).to eq(0)
    end

    it "returns not found if frame does not exist" do
      delete "/frames/999"
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Frame not found")
    end
  end
end