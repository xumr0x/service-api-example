# Service API tutorial

In this tutorial, we will create a multi-server architecture for making a simple app for creating and retrieving a list of users from the database!

### [Part 1 - Setting up your cloud architecture](cloud.md)

### [Part 2 - Setting up your Sinatra app](sinatra.md)

## Flow

![flow](https://static.swimlanes.io/e86bed77d0258067e318c30e9f2c52fa.png)

## Architecture

- Sinatra Frontend (1 Droplet)
  - Responsible for asking the Service API for the list of users, and render a html for it.
- Sinatra Service API (1 Droplet)
  - Responsible for talking to Postgres
- Postgres DB (1 Database)
