require 'rails_helper'

RSpec.describe EventPolicy do
  let(:user) { User.new }
  # объект тестирования (политика)
  subject { EventPolicy }

  context 'when user in not an owner' do
    let(:event) {Event.create(title: 'Test', address: 'somewhere', datetime: Time.now)}
    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(user, event) }
    end
  end

  context 'when user in an owner' do
    let(:event) {
      Event.create(title: 'Test', address: 'somewhere', datetime: Time.now, user: user)
    }
    permissions :show?, :edit?, :update?, :destroy? do
      it { is_expected.to permit(user, event) }
    end
  end

  context 'when anon user' do
    let(:event) { Event.create(title: 'Test', address: 'somewhere', datetime: Time.now)}
    permissions :show?, :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(nil, event) }
    end
  end
end
