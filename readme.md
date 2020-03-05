# Service API tutorial [![Maintainability](https://api.codeclimate.com/v1/badges/df2e641b05b3d31eeb4d/maintainability)](https://codeclimate.com/github/hojulian/service-api-example/maintainability)

![web](docs/images/frontend.png)

In this tutorial, we will create a multi-server architecture for making a simple app for creating and retrieving a list of users from the database!

*This is originally made for [COSI 105b: Software Engineering for Scalability](http://cosi105b.s3-website-us-west-2.amazonaws.com/) @ Brandeis University under Professor Pito Salas.*

## Start here

### [Part 1 - Cloud architecture](docs/cloud.md)

### [Part 2 - Sinatra app](docs/sinatra.md)

### [Part 3 - CI/CD](docs/cicd.md)

### [Part 4 - Service Discovery](docs/discovery.md)

## Flow

![flow](https://static.swimlanes.io/e86bed77d0258067e318c30e9f2c52fa.png)

## Architecture

- Sinatra Frontend (1 Droplet)
  - Responsible for asking the Service API for the list of users, and render a html page for it.
- Sinatra Service API (1 Droplet)
  - Responsible for talking to Postgres and retrieving Users' information.
- Postgres DB (1 Database)
