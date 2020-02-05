# Service API tutorial - Sinatra

## Prerequisites

- You must complete part 1 first, with 2 droplets and a database up and running on DO

## Step 1 - Implement Service API

- Implement the route `get '/users'`
  - This route is responsible for returning all the users in the database
  - It should returns an array of users in `json` format
  - And a `200 OK` back to the caller

## Step 2 - Implement Frontend

- Implement the route `get '/'`
  - This route is responsible for calling `http://API_HOST/users` and displaying the results in a nicely formatted table on a html page
  - On the top of the page, it should display the total number of users in the database
