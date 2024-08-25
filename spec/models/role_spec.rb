require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { create(:role) }

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
end
