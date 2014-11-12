class TeamCityRestProject < Project

  validates_presence_of :ci_build_identifier, :ci_base_url, unless: ->(project) { project.webhooks_enabled }

  alias_attribute :build_status_url, :feed_url
  alias_attribute :project_name, :feed_url

  def feed_url
    url_with_scheme "#{ci_base_url}/app/rest/builds?locator=running:all,buildType:(id:#{ci_build_identifier}),personal:false"
  end

  def fetch_payload
    TeamCityXmlPayload.new(self)
  end

  def webhook_payload
    TeamCityJsonPayload.new
  end

  def has_dependencies?
    true
  end

end
