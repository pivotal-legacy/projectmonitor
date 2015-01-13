require 'spec_helper'

describe TddiumProject, :type => :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ci_build_identifier) }
    it { is_expected.to validate_presence_of(:ci_base_url) }
    it { is_expected.to validate_presence_of(:ci_auth_token) }
  end

  subject { build(:tddium_project) }

  describe 'accessors' do
    describe '#feed_url' do
      let(:tddium_url) { 'http://tddium.acmecorp.com' }
      subject { FactoryGirl.build(:tddium_project, :ci_base_url => tddium_url).feed_url }
      it { is_expected.to eq([tddium_url, 'cc/b5bb9d8014a0f9b1d61e21e796d78dccdf1352f2/cctray.xml'].join('/')) }
    end

    describe '#build_status_url' do
      subject { super().build_status_url }
      it { is_expected.to eq('https://api.tddium.com/cc/b5bb9d8014a0f9b1d61e21e796d78dccdf1352f2/cctray.xml') }
    end

    describe '#ci_build_identifier' do
      subject { super().ci_build_identifier }
      it { is_expected.to eq('Test Project A') }
    end

    describe '#fetch_payload' do
      subject { super().fetch_payload }
      it { is_expected.to be_an_instance_of(TddiumPayload) }
    end
  end
end
