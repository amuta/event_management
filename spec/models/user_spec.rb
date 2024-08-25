# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    it { should validate_presence_of(:password_digest) }
  end

  describe 'Callbacks' do
    it 'downcases the email before saving' do
      user = create(:user, email: 'User@Example.com')
      expect(user.reload.email).to eq('user@example.com')
    end
  end
end
