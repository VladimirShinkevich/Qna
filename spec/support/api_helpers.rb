module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, optional = {})
    send method, path, optional = {}
  end
end
