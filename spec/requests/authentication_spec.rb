require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/signup' do
    post 'Creates a user and returns an authentication token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, description: 'Email of the user', example: 'user@example.com' },
          name: { type: :string, description: 'Name of the user', example: 'John Doe' },
          password: { type: :string, description: 'Password for the user account', example: 'securePassword123' },
          password_confirmation: { type: :string, description: 'Confirmation of the password', example: 'securePassword123' }
        },
        required: ['email', 'name', 'password', 'password_confirmation']
      }

      response '201', 'User created successfully' do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' }
               }

        let(:user) { { email: 'test@example.com', name: 'John Doe', password: 'securePassword123', password_confirmation: 'securePassword123' } }
        run_test!
      end

      response '422', 'Validation errors' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string, example: 'Email is invalid' }
                 }
               },
               required: ['errors']

        let(:user) { { email: 'invalid_email', name: 'John Doe', password: 'securePassword123', password_confirmation: 'notmatchingpassword' } }
        run_test!
      end
    end
  end

  path '/login' do
    post 'Authenticates a user and returns an authentication token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, description: 'Email of the user', example: 'user@example.com' },
          password: { type: :string, description: 'Password for the user account', example: 'securePassword123' }
        },
        required: ['email', 'password']
      }

      response '200', 'User authenticated successfully' do
        schema type: :object,
               properties: {
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' }
               }

        let(:credentials) { { email: 'test@example.com', password: 'securePassword123' } }
        run_test!
      end

      response '401', 'Invalid email or password' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid email or password' }
               }

        let(:credentials) { { email: 'test@example.com', password: 'wrongPassword' } }
        run_test!
      end

      response '422', 'Email is required' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Email is required' }
               }

        let(:credentials) { { password: 'securePassword123' } }
        run_test!
      end

      response '422', 'Password is required' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Password is required' }
               }

        let(:credentials) { { email: 'test@example.com' } }
        run_test!
      end
    end
  end
end
