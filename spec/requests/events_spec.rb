require 'rails_helper'

require 'swagger_helper'

RSpec.describe 'Events API', type: :request do
  path '/events' do
    let(:user) { create(:user) }
    let(:Authorization) { "Bearer #{user.auth_token}" }

    get 'Retrieves a list of events' do
      tags 'Events'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of events per page'

      response '200', 'Events retrieved successfully' do
        schema type: :object,
               properties: {
                 events: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       description: { type: :string },
                       location: { type: :string },
                       start_time: { type: :string, format: 'date-time' },
                       end_time: { type: :string, format: 'date-time' },
                       user_id: { type: :integer }
                     }
                   }
                 },
                 page: { type: :integer },
                 total_pages: { type: :integer }
               }

        let(:page) { 1 }
        let(:per_page) { 10 }
        run_test!
      end
    end


    post 'Creates an event' do
      tags 'Events'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Name of the event', example: 'Tech Meetup' },
          description: { type: :string, description: 'Description of the event', example: 'A meetup for tech enthusiasts' },
          location: { type: :string, description: 'Location of the event', example: '123 Main St' },
          start_time: { type: :string, format: 'date-time', description: 'Start time of the event', example: '2024-08-30 18:00:00' },
          end_time: { type: :string, format: 'date-time', description: 'End time of the event', example: '2024-08-30 20:00:00' }
        },
        required: ['name', 'location', 'start_time', 'end_time']
      }
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '201', 'Event created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 location: { type: :string },
                 start_time: { type: :string, format: 'date-time' },
                 end_time: { type: :string, format: 'date-time' },
                 user_id: { type: :integer }
               }

        let(:event) { { name: 'Tech Meetup', description: 'A meetup for tech enthusiasts', location: '123 Main St', start_time: '2024-08-30 18:00:00', end_time: '2024-08-30 20:00:00' } }
        run_test!
      end
      response '422', 'Validation errors' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string, example: 'Name can\'t be blank' }
                 }
               },
               required: ['errors']

        let(:event) { { name: '', location: '123 Main St', start_time: '2024-08-30 18:00:00', end_time: '2024-08-30 20:00:00' } }
        run_test!
      end
    end
  end
end
