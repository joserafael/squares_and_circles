require 'rails_helper'

RSpec.describe 'Application', type: :request do
  path '/' do
    get('root path') do
      tags 'Application'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 message: { type: :string }
               }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Hello, world!')
        end
      end
    end
  end
end
