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
          email: { type: :string },
          name: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: ['email', 'name', 'password', 'password_confirmation']
      }

      response '201', 'user created' do
        byebug
        let(:user) { { email: 'test@example.com', name: 'test', password: 'password', password_confirmation: 'password' } }
        run_test!
      end

      response '422', 'invalid email' do
        let(:user) { { email: 'invalid_email', name: 'test', password: 'password', password_confirmation: 'password' } }
        run_test!
      end

      response '422', 'password and password confirmation do not match' do
        let(:user) { { email: 'invalid_email', name: 'test', password: 'password', password_confirmation: 'notpassword' } }
        run_test!
      end

      response '422', 'email is required' do
        let(:user) { { name: 'test', password: 'password', password_confirmation: 'password' } }
        run_test!
      end

      response '422', 'name is required' do
        let(:user) { { email: 'test@example.com', password: 'password', password_confirmation: 'password' } }
        run_test!
      end
    end
  end
end
