require 'rails_helper'

RSpec.describe EventPolicy do
  let(:user) { FactoryBot.create(:user, email: 'lo@lo.lo') }
  # объект тестирования (политика)
  subject { EventPolicy }

  context 'when user in not an owner' do
    let(:event) { FactoryBot.create(:event) }

    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(user, event) }
    end

    permissions :show? do
      it { is_expected.to permit(user, event) }
    end
  end

  context 'when user in an owner' do
    let(:event) { FactoryBot.create(:event, user: user) }

    permissions :show?, :edit?, :update?, :destroy? do
      it { is_expected.to permit(user, event) }
    end
  end

  context 'when anon user' do
    let(:event) { FactoryBot.create(:event) }

    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(nil, event) }
    end

    permissions :show? do
      it { is_expected.to permit(nil, event) }
    end
  end
end
