require 'uri'
require 'multi_json'

class RequestAttributes
  attr_reader :payload

  def initialize(request)
    decoded_string = URI.decode(request.body.string.gsub(/payload=/, ''))
    json_payload = MultiJson.load(decoded_string, :symbolize_keys => true)
    @payload = json_payload
  end

  def token
    payload.dig(:token)
  end

  def response_url
    payload.dig(:response_url)
  end

  def callback_id
    payload.dig(:callback_id)
  end

  def team_id
    payload.dig(:team, :id)
  end

  def channel_id
    payload.dig(:channel, :id)
  end

  def channel_name
    payload.dig(:channel, :name)
  end

  def user_id
    payload.dig(:user, :id)
  end

  def user_name
    payload.dig(:user, :name)
  end

  def type
    payload.dig(:type)
  end

  def actions
    payload.dig(:actions) || []
  end

  def action
    actions.first
  end

  def action_type
    action.dig(:type)
  end

  def action_value
    action_type == 'select' ? selected_option.dig(:value) : action.dig(:value)
  end

  def selected_option
    action.dig(:selected_options).first
  end

  def attributes_hash
    {
      team_id: team_id,
      channel_id: channel_id,
      channel_name: channel_name,
      user_id: user_id,
      user_name: user_name,
      action_value: action_value,
    }
  end
end
