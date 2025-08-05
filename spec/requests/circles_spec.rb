require 'rails_helper'

RSpec.describe "Circles", type: :request do
  let(:frame) { Frame.create(center_x: 10, center_y: 10, width: 20, height: 20) }

  describe "POST /frames/:frame_id/circles" do
    it "creates a new circle" do
      post "/frames/#{frame.id}/circles", params: { circle: { center_x: 10, center_y: 10, diameter: 5 } }
      expect(response).to have_http_status(:created)
    end

    it "returns unprocessable entity if circle is invalid" do
      post "/frames/#{frame.id}/circles", params: { circle: { center_x: 10, center_y: 10, diameter: 30 } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PUT /circles/:id" do
    it "updates a circle" do
      circle = frame.circles.create(center_x: 10, center_y: 10, diameter: 5)
      put "/circles/#{circle.id}", params: { circle: { center_x: 12, center_y: 12 } }
      expect(response).to have_http_status(:ok)
    end

    it "returns not found if circle does not exist" do
      put "/circles/999", params: { circle: { center_x: 12, center_y: 12 } }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Circle not found")
    end
  end

  describe "DELETE /circles/:id" do
    it "deletes a circle" do
      circle = frame.circles.create(center_x: 10, center_y: 10, diameter: 5)
      delete "/circles/#{circle.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Circle deleted successfully")
      expect(Circle.count).to eq(0)
    end

    it "returns not found if circle does not exist" do
      delete "/circles/999"
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Circle not found")
    end
  end

  describe "GET /circles" do
    it "returns circles within a radius" do
      frame.circles.create(center_x: 10, center_y: 10, diameter: 5)
      get "/circles", params: { center_x: 10, center_y: 10, radius: 10 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).count).to eq(1)
    end
  end
end