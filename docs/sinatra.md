# Service API tutorial - Sinatra

## Prerequisites

- You must complete part 1 first, with 2 droplets and a database up and running on DO

## Step 1 - Create databases remotely

Navigate to the `./service-api-sinatra` directory and create the databases using `rake` on your local machine

*Replace `$DB_HOST` with the public address of the database (looks something like this: `postgres-sinatra...db.ondigitalocean.com`)*

*Replace `$DB_PASSWORD` with the database `doadmin` user password*

**Do this for production as well**

```bash
rake db:create DB_HOST=$DB_HOST DB_PASSWORD=$DB_PASSWORD RACK_ENV=development
```

This will create these databases: `srv_api_dev` and `srv_api_test`

Then migrates the `User` table:

**Do this for production as well**

```bash
rake db:migrate DB_HOST=$DB_HOST DB_PASSWORD=$DB_PASSWORD RACK_ENV=development
```

## Step 2 - Implement Service API

- Implement the route `get '/users'`
  - This route is responsible for returning all the users in the database
  - It should returns an array of users in `json` format
  - And a `200 OK` back to the caller

## Step 3 - Implement Frontend

- Implement the route `get '/'`
  - This route is responsible for calling `http://API_HOST/users` and displaying the results in a nicely formatted table on a html page
  - On the top of the page, it should display the total number of users in the database

## Step 4 - Running locally

To connect to the remote database, you should always run your apps like this:

```bash
# For service-api, running on port 4568
bundle exec puma -p 4568 DB_HOST=$DB_HOST DB_PASSWORD=$DB_PASSWORD

# For frontend, running on port 4567
bundle exec puma -p 4567 API_HOST=127.0.0.1:4568
```

This will ensure they can all connect to each other.

## Step 5 - Running remotely

Now that you have tested it works locally, it is time to have it run on the cloud servers.

*Replace `$REPO` with your own github repo (looks like `git@github.com:xumr0x/service-api-example.git`)*

*Replace `$API_HOST` with the private address of your `service-api` droplet, you can find that with `doctl compute droplet list`*

```bash
# For service-api
doctl compute ssh --ssh-command "git clone $REPO && cd service-api-example && bundle && rackup -p 80 DB_HOST=$DB_HOST DB_PASSWORD=$DB_PASSWORD"

# For frontend
doctl compute ssh --ssh-command "API_HOST=$API_HOST git clone $REPO && cd service-api-example && bundle && rackup -p 80"
```
