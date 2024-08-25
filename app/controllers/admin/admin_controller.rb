# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :set_user, only: %i[add_user_role remove_user_role index_user_roles]
    before_action :set_role, only: %i[add_user_role remove_user_role]

    before_action :authorize_add_user_role!, only: [:add_user_role]
    before_action :authorize_remove_user_role!, only: [:remove_user_role]
    before_action :authorize_index_roles!, only: [:index_roles]
    before_action :authorize_index_users!, only: [:index_users]
    before_action :authorize_index_user_roles!, only: [:index_user_roles]

    # GET /admin/roles
    def index_roles
      roles = Role.all.page(params[:page]).per(params[:per_page])

      render json: { roles: roles.map(&:as_json), page: roles.current_page, total_pages: roles.total_pages },
             status: :ok
    end

    # GET /admin/users
    def index_users
      users = User.all.page(params[:page]).per(params[:per_page])

      render json: { users: users.map(&:as_json), page: users.current_page, total_pages: users.total_pages },
             status: :ok
    end

    # GET /admin/users/:user_id/roles
    def index_user_roles
      render json: @user.roles, status: :ok
    end

    # POST /admin/users/:user_id/roles/:role_id/add
    def add_user_role
      if @user.roles << @role
        render json: { message: 'Role added successfully.' }, status: :ok
      else
        render_errors('Failed to add role.', status: :unprocessable_entity)
      end
    end

    # DELETE /admin/users/:user_id/roles/:role_id/remove
    def remove_user_role
      if @user.roles.delete(@role)
        render json: { message: 'Role removed successfully.' }, status: :ok
      else
        render_errors('Failed to remove role.', status: :unprocessable_entity)
      end
    end

    private

    def authorize_add_user_role!
      return if user_allowed?('__add_user_role__')

      unauthorized!
    end

    def authorize_remove_user_role!
      return if user_allowed?('__remove_user_role__')

      unauthorized!
    end

    def authorize_index_roles!
      return if user_allowed?('__index_roles__')

      unauthorized!
    end

    def authorize_index_users!
      return if user_allowed?('__index_users__')

      unauthorized!
    end

    def authorize_index_user_roles!
      return if user_allowed?('__index_user_roles__')

      unauthorized!
    end

    def unauthorized!
      render_errors('Unauthorized', status: :unauthorized)
    end

    def set_user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render_errors('User not found', status: :not_found)
    end

    def set_role
      @role = Role.find(params[:role_id])
    rescue ActiveRecord::RecordNotFound
      render_errors('Role not found', status: :not_found)
    end
  end
end
