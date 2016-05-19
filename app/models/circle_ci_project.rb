class CircleCiProject < Project

  validates_presence_of :circleci_username, :ci_build_identifier, :ci_auth_token, unless: ->(project) { project.webhooks_enabled }

  alias_attribute :build_status_url, :feed_url

  def self.project_specific_attributes
    ['circleci_username', 'ci_build_identifier', 'ci_auth_token']
  end

  def feed_url
    "https://circleci.com/api/v1/project/#{circleci_username}/#{ci_build_identifier}/tree/#{build_branch.presence || 'master'}?circle-token=#{ci_auth_token}"
  end

  def fetch_payload
    CircleCiFetchPayload.new
  end

  def webhook_payload
    CircleCiWebhookPayload.new
  end

  def accept_mime_types
    'application/json'
  end

  def requires_branch_name?
    true
  end

end
