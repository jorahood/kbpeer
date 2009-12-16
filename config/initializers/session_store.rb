# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kbpeer_session',
  :secret      => '6af820ffd5f4dc9af81bd426486763afca9ac7bafa117abc343d114befc7a290268e2f7a35d1da2df8c0e2eb1b4f19c9155fa70f25414b44824f1cd57bbfae5c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
