require 'rails_helper'

RSpec.describe "Frames", type: :request do
  path '/frames' do
    post 'Creates a Frame' do
      tags 'Frames'
      consumes 'application/json'
      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          frame: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              width: { type: :number },
              height: { type: :number },
              circles_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    center_x: { type: :number },
                    center_y: { type: :number },
                    diameter: { type: :number }
                  },
                  required: %w[center_x center_y diameter]
                }
              }
            },
            required: %w[center_x center_y width height]
          }
        },
        required: %w[frame]
      }

      response '201', 'frame created' do
        let(:frame) { { frame: { center_x: 10, center_y: 10, width: 20, height: 20 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:frame) { { frame: { center_x: 10, center_y: 10, width: -20, height: 20 } } }
        run_test!
      end
    end

    get 'Retrieves all Frames' do
      tags 'Frames'
      produces 'application/json'

      response '200', 'frames found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   center_x: { type: :number },
                   center_y: { type: :number },
                   width: { type: :number },
                   height: { type: :number },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 }
               }
        run_test!
      end
    end
  end

  path '/frames/{id}' do
    get 'Retrieves a Frame' do
      tags 'Frames'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'frame found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 center_x: { type: :number },
                 center_y: { type: :number },
                 width: { type: :number },
                 height: { type: :number },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' },
                 circles: {
                   type: :array,
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
                 }
               }
        let(:id) { Frame.create(center_x: 10, center_y: 10, width: 20, height: 20).id }
        run_test!
      end

      response '404', 'frame not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a Frame' do
      tags 'Frames'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          frame: {
            type: :object,
            properties: {
              center_x: { type: :number },
              center_y: { type: :number },
              width: { type: :number },
              height: { type: :number }
            }
          }
        }
      }

      response '200', 'frame updated' do
        let(:id) { Frame.create(center_x: 10, center_y: 10, width: 20, height: 20).id }
        let(:frame) { { frame: { center_x: 15, center_y: 15 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Frame.create(center_x: 10, center_y: 10, width: 20, height: 20).id }
        let(:frame) { { frame: { width: -10 } } }
        run_test!
      end

      response '404', 'frame not found' do
        let(:id) { 'invalid' }
        let(:frame) { { frame: { center_x: 15 } } }
        run_test!
      end
    end

    delete 'Deletes a Frame' do
      tags 'Frames'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'frame deleted' do
        let(:id) { Frame.create(center_x: 10, center_y: 10, width: 20, height: 20).id }
        run_test!
      end

      response '404', 'frame not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
