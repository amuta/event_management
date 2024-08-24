require 'rails_helper'

require 'swagger_helper'

RSpec.describe 'Events API', type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { "Bearer #{user.auth_token}" }
  path '/events' do
    get 'Retrieves a list of events' do
      tags 'Events'
      produces 'application/json'
      # Pagination parameters
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of events per page'

      # Filter parameters
      parameter name: :user_id, in: :query, type: :integer, description: 'Filter by User ID'
      parameter name: :start_time, in: :query, type: :string, format: 'date-time', description: 'Filter by start time (events starting from this time onwards)'
      parameter name: :end_time, in: :query, type: :string, format: 'date-time', description: 'Filter by end time (events ending before this time)'
      parameter name: :name, in: :query, type: :string, description: 'Filter by event name (partial match)'
      parameter name: :location, in: :query, type: :string, description: 'Filter by event location (partial match)'


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
      response '401', 'Only authenticated users can create events' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string, example: 'Unauthorized' }
                 }
               },
               required: ['errors']

        let(:event) { { name: '', location: '123 Main St', start_time: '2024-08-30 18:00:00', end_time: '2024-08-30 20:00:00' } }
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
  path '/events/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID of the event'

    get 'Retrieves an event' do
      tags 'Events'
      produces 'application/json'

      response '200', 'Event retrieved successfully' do
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

        let(:id) { create(:event, user: user).id }
        run_test!
      end

      response '404', 'Event not found' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string, example: 'Event not found' }
                 }
               }

        let(:id) { 0 }
        run_test!
      end
    end

    put 'Updates an event' do
      tags 'Events'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Name of the event', example: 'Updated Tech Meetup' },
          description: { type: :string, description: 'Updated description of the event', example: 'An updated meetup for tech enthusiasts' },
          location: { type: :string, description: 'Updated location of the event', example: '123 Updated Main St' },
          start_time: { type: :string, format: 'date-time', description: 'Updated start time of the event', example: '2024-08-30 19:00:00' },
          end_time: { type: :string, format: 'date-time', description: 'Updated end time of the event', example: '2024-08-30 21:00:00' }
        },
        anyOf: ['name', 'description', 'location', 'start_time', 'end_time']
      }
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '200', 'Event updated successfully' do
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

        let(:id) { create(:event, user: user).id }
        let(:event) { { location: '123 Updated Main St' } }
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

        let(:id) { create(:event, user: user).id }
        let(:event) { { name: ''} }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string, example: 'Unauthorized' } }
               }
        let(:id) { create(:event).id }  # Event not created by current user
        let(:event) { { name: 'This is not my event!'} }
        run_test!
      end
    end

    delete 'Deletes an event' do
      tags 'Events'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true
      parameter name: :id, in: :path, type: :integer, description: 'ID of the event', required: true
    
      response '204', 'Event deleted successfully' do
        let(:id) { create(:event, user: user).id }
        run_test!
      end
    
      response '404', 'Event not found' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string, example: 'Event not found' } }
               }
    
        let(:id) { 0 }
        run_test!
      end
    
      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 errors: { type: :array, items: { type: :string, example: 'Unauthorized' } }
               }
    
        let(:Authorization) { "Bearer invalid_token" }
        let(:id) { create(:event).id }  # Event not created by the current user
        run_test!
      end
    end
  end
end