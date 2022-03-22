# frozen_string_literal: true

module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, _optional = {})
    send method, path, optional = {}
  end
end
