Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.dig(:google_oauth_client_id), Rails.application.credentials.dig(:google_oauth_client_secret), {
    scope: 'email, profile',
    redirect_uri: 'http://localhost:3000/users/auth/google_oauth2/callback'
  }
end
