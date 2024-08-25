require 'rails_helper'

RSpec.describe Role, type: :model do
  before(:each) do
    Role.find_or_initialize_by(name: 'admin') do |role|
      role.save!(validate: false) if role.new_record?
    end
  end

  let!(:role) { create(:role) }
  let(:admin_role) { Role.admin }

  describe 'validations' do
    it 'is valid with a unique name' do
      expect(role).to be_valid
    end

    it 'is invalid without a name' do
      role.name = nil
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      duplicate_role = Role.new(name: role.name)

      expect(duplicate_role).not_to be_valid
      expect(duplicate_role.errors[:name]).to include('has already been taken')
    end
  end

  describe '#permits?' do
    it 'permits any behavior if the role is admin' do
      expect(admin_role.permits?('any_behavior')).to be true
    end

    it 'permits behavior if it is included in the permissions' do
      role.permissions = %w[read write]
      expect(role.permits?('read')).to be true
      expect(role.permits?('write')).to be true
    end

    it 'does not permit behavior if it is not included in the permissions' do
      role.permissions = ['read']
      expect(role.permits?('write')).to be false
    end
  end

  describe 'cant_modify_admin_role validation' do
    it 'does not allow the admin role to be modified' do
      admin_role.name = 'superadmin'
      expect(admin_role).not_to be_valid
      expect(admin_role.errors[:base]).to include('Cannot modify admin role')
    end

    it 'allows non-admin roles to be modified' do
      role.name = 'new_role_name'
      expect(role).to be_valid
    end

    it 'does not allow changing a non-admin role to admin' do
      role.name = 'admin'
      expect(role).not_to be_valid
      expect(role.errors[:base]).to include('Cannot modify admin role')
    end
  end
end
