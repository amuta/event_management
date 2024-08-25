# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Admin API', type: :request do
  let!(:admin_role) { create(:role, :admin) }
  let!(:event_manager_role) { create(:role, :event_manager) }
  let!(:user_manager_role) { create(:role, :user_manager) }

  let(:admin_user) { create(:user, roles: [admin_role]) }
  let(:regular_user) { create(:user) }

  let(:Authorization) { "Bearer #{admin_user.auth_token}" }
  let(:page) { 1 }
  let(:per_page) { 10 }

  path '/admin/users' do
    get 'Retrieves all users' do
      tags 'Admin'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of users per page'
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '200', 'Users retrieved successfully' do
        schema type: :object,
               properties: {
                 users: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       email: { type: :string },
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' }
                     }
                   }
                 },
                 page: { type: :integer },
                 total_pages: { type: :integer }
               }

        before do
          admin_user
          regular_user
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data['users'].count).to eq(2)
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer #{regular_user.auth_token}" }

        run_test!
      end
    end
  end

  path '/admin/roles' do
    get 'Retrieves all roles' do
      tags 'Admin'
      produces 'application/json'

      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '200', 'Roles retrieved successfully' do
        schema type: :object,
               properties: {
                 roles: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       permissions: { type: :Array, items: { type: :string, example: '__add_user_role__' } },
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' }
                     }
                   }
                 },
                 page: { type: :integer },
                 total_pages: { type: :integer }
               }

        before do
          admin_role
          event_manager_role
          user_manager_role
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data.size).to eq(3)
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer #{regular_user.auth_token}" }

        run_test!
      end
    end
  end

  path '/admin/users/{user_id}/roles' do
    get 'Retrieves roles for a specific user' do
      tags 'Admin'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'User ID'
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '200', 'Roles retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   permissions: { type: :array, items: { type: :string } }
                 }
               }

        let(:user_id) { regular_user.id }

        before do
          regular_user.roles << event_manager_role
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(:ok)
          expect(data.size).to eq(1)
          expect(data.first['name']).to eq('event_manager')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer #{regular_user.auth_token}" }
        let(:user_id) { regular_user.id }

        run_test!
      end
    end
  end

  path '/admin/users/{user_id}/roles/{role_id}/add' do
    post 'Adds a role to a specific user' do
      tags 'Admin'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'User ID'
      parameter name: :role_id, in: :path, type: :integer, description: 'Role ID'
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '200', 'Role added successfully' do
        let(:user_id) { regular_user.id }
        let(:role_id) { user_manager_role.id }

        run_test! do
          expect(regular_user.reload.roles).to include(user_manager_role)
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer #{regular_user.auth_token}" }
        let(:user_id) { regular_user.id }
        let(:role_id) { user_manager_role.id }

        run_test!
      end
    end
  end

  path '/admin/users/{user_id}/roles/{role_id}/remove' do
    delete 'Removes a role from a specific user' do
      tags 'Admin'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'User ID'
      parameter name: :role_id, in: :path, type: :integer, description: 'Role ID'
      parameter name: :Authorization, in: :header, type: :string, description: 'JWT Token', required: true

      response '200', 'Role removed successfully' do
        before do
          regular_user.roles << event_manager_role
        end

        let(:user_id) { regular_user.id }
        let(:role_id) { event_manager_role.id }

        run_test! do
          expect(regular_user.reload.roles).not_to include(event_manager_role)
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer #{regular_user.auth_token}" }
        let(:user_id) { regular_user.id }
        let(:role_id) { event_manager_role.id }

        run_test!
      end
    end
  end
end
