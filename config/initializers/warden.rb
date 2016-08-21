require 'authentication_token_strategy'

Warden::Strategies.add(:authentication_token, AuthenticationTokenStrategy)

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :authentication_token
  manager.failure_app = UnauthenticatedController
end
