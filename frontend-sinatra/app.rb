# entry point
require 'sinatra'

# put your service-api droplet's private ip here.
set :api, ENV['API_HOST']

get '/' do
  'Implement me!'
end