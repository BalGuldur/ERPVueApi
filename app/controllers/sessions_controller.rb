class SessionsController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def create
    puts "auth_hash #{auth_hash.as_json}"
    puts "session #{session.as_json}"
    fullname = auth_hash["info"]["name"]
    payload = auth_hash.as_json.merge!({admin: false})
    # TODO: Добавить шифрование JWT с помощью RSA
    token = JWT.encode payload, Rails.application.secrets.jwt_secret, 'HS256'
    # TODO: Вынести localhost:8080 в файл настройки
    render json: {token: token}, status: :ok
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
