require 'rails_helper'

describe ProfilePolicy do
  subject { described_class }

  context 'for a visitor' do
    let(:member) { nil }
    let(:profile) { FactoryGirl.create(:profile) }

    permissions :index?, :show?, :new?, :edit?, :create?,
  end
end
