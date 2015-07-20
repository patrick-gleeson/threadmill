require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  describe 'ActiveRecord associations' do
    it { expect(user).to have_many(:orders) }
  end
end
