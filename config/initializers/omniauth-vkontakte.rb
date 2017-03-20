Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, Rails.application.secrets.vkontakte_api_key, Rails.application.secrets.vkontakte_api_secret,
    {
      provider_ignores_state: true,
      scope: 'email',
      display: 'popup',
      lang: 'ru',
      https: 1,
      image_size: 'original',
      redirect_url: 'http://localhost:8080/vkauth'
    }
end