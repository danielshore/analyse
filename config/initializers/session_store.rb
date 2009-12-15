# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_analyse_session',
  :secret      => 'c70e0b11c714a5332f357077c974710f1889a8cf9387b0b17461f26d950b8e2b9d797c10089da9e6f8138ebf381cbfd77da61b78fbaaaa695904df9dda5e4521'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
