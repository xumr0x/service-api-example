# entry point
require 'sinatra'

# retrieve your api host address like this
#   settings.api => "someaddress.ondigitalocean.com"
set :api, ENV['API_HOST']

get '/' do
  'Implement me!'
end