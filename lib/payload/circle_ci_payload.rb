class CircleCiPayload < Payload

  def building?
    status_content.first['status'] == 'running' || status_content.first['status'] == 'queued'
  end

  def content_ready?(content)
    content['status'] != 'running' && content['status'] != 'queued' && content['outcome'].present?
  end

  def convert_content!(raw_content)
    json_content = JSON.parse(raw_content)
    Array.wrap(json_content['payload'])
  rescue => e
    handle_processing_exception e
  end

  def convert_webhook_content!(raw_content)
    Array.wrap(JSON.parse(raw_content)['payload'])
  end

  def parse_success(content)
    content['outcome'] == 'success'
  end

  def parse_url(content)
    self.parsed_url = content['build_url'].split('builds').first
    content['build_url']
  end

  def parse_build_id(content)
    content['build_num']
  end

  def parse_published_at(content)
    if content['start_time']
      Time.parse(content['start_time'])
    else
      Time.now
    end
  end

  def build_branch_matches(branch_name)
    !!(/#{branch_name}/ =~ status_content.first['branch'])
  end

end
