module ApplicationHelper
  def broadcast(channel, data)
    message = { channel: channel, data: data }
    uri = URI.parse('http://0.0.0.0:9292/faye')
    Net::HTTP.post_form(uri, message: message.to_json)
  end
end
