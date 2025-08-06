require 'rails_helper'

RSpec.describe "Circles", type: :request do
  let(:frame) { Frame.create!(center_x: 10, center_y: 10, width: 20, height: 20) }

  path '/frames/{frame_id}/circles' do
    post 'Creates a Circle within a Frame' do
      tags 'Circles'
      consumes 'application/json'
      parameter name: :frame_id, in: :path, type: :string
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              diameter: { type: :number }
            },
            required: %w[center_x center_y diameter]
          }
        },
        required: %w[circle]
      }

      response '201', 'circle created' do
        let(:frame_id) { frame.id }
        let(:circle) { { circle: { center_x: 10, center_y: 10, diameter: 5 } } }
        run_test! { header 'Host', 'localhost' }
      end

      response '422', 'invalid request' do
        let(:frame_id) { frame.id }
        let(:circle) { { circle: { center_x: 10, center_y: 10, diameter: 30 } } }
        run_test! { header 'Host', 'localhost' }
      end
    end
  end

  path '/circles' do
    get 'Searches for Circles' do
      tags 'Circles'
      produces 'application/json'
      parameter name: :center_x, in: :query, type: :number, required: false
      parameter name: :center_y, in: :query, type: :number, required: false
      parameter name: :radius, in: :query, type: :number, required: false
      parameter name: :frame_id, in: :query, type: :integer, required: false

      response '200', 'circles found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   center_x: { type: :number },
                   center_y: { type: :number },
                   diameter: { type: :number },
                   frame_id: { type: :integer },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 }
               }
        let(:center_x) { 10 }
        let(:center_y) { 10 }
        let(:radius) { 10 }
        before { frame.circles.create(center_x: 10, center_y: 10, diameter: 5) }
        run_test! { header 'Host', 'www.example.com' }
      end
    end
  end

  path '/circles/{id}' do
    put 'Updates a Circle' do
      tags 'Circles'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              diameter: { type: :number }
            }
          }
        }
      }

      response '200', 'circle updated' do
        let(:id) { frame.circles.create(center_x: 10, center_y: 10, diameter: 5).id }
        let(:circle) { { circle: { center_x: 12, center_y: 12 } } }
        run_test! { header 'Host', 'www.example.com' }
      end

      response '422', 'invalid request' do
        let(:id) { frame.circles.create(center_x: 10, center_y: 10, diameter: 5).id }
        let(:circle) { { circle: { diameter: 30 } } }
        run_test! { header 'Host', 'www.example.com' }
      end

      response '404', 'circle not found' do
        let(:id) { 'invalid' }
        let(:circle) { { circle: { center_x: 12 } } }
        run_test! { header 'Host', 'www.example.com' }
      end
    end

    delete 'Deletes a Circle' do
      tags 'Circles'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'circle deleted' do
        let(:id) { frame.circles.create(center_x: 10, center_y: 10, diameter: 5).id }
        run_test! { header 'Host', 'www.example.com' }
      end

      response '404', 'circle not found' do
        let(:id) { 'invalid' }
        run_test! { header 'Host', 'www.example.com' }
      end
    end
  end
end
