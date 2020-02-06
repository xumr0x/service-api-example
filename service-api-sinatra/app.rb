# entry point
require 'sinatra'

require_relative './models/user'

# Retrieve all users from database.
get '/users' do
  'Implement me!'
end

# Create n users.
post '/users' do
  count = params[:n] || 1
  'Implement me!'
end
