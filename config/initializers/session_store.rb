# Be sure to restart your server when you modify this file.

# We are setting up session_store settings for staging and production
# in related environment config files:
# config/environments/*.rb
if Rails.development? || Rails.env.test?
  Rails.application.config.session_store :cookie_store, key: '_qae_session'
end
