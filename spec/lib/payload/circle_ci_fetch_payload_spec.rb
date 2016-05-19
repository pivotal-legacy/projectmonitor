require 'spec_helper'
require Rails.root.join('spec', 'shared', 'json_payload_examples')

describe CircleCiFetchPayload do

  let(:fixture_file)      { "success.json" }
  let(:fixture_content)   { load_fixture('circleci_fetch_examples', fixture_file) }
  let(:payload)           { CircleCiFetchPayload.new.tap{|p| p.status_content = fixture_content} }
  let(:converted_content) { payload.status_content.first }

  it_behaves_like "a JSON payload"

  describe '#content_ready?' do
    # success.json & failure.json covered in shared examples
    context 'outcome is empty' do
      let(:fixture_file) { "outcome_is_empty.json" }
      it { expect(payload.content_ready?(converted_content)).to be false }
    end
  end

  describe '#parse_url' do
    it { expect(payload.parse_url(converted_content)).to eq('https://circleci.com/gh/auser/project/172') }
  end

  describe '#parse_build_id' do
    it { expect(payload.parse_build_id(converted_content)).to eq(172) }
  end

  describe '#parse_published_at' do
    it { expect(payload.parse_published_at(converted_content).round).to eq(Time.utc(2013, 10, 15, 8, 47, 30)) }
  end

end
