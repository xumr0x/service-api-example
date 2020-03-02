# Service API tutorial - Service Discovery

## Prerequisites

- Part 1, 2, 3 of the Service API tutorial series
- Redis installed locally
  - [https://redis.io/download](https://redis.io/download)
  - You can use `brew install redis` on Mac
- Latest version of [https://github.com/xumr0x/service-api-example](https://github.com/xumr0x/service-api-example)

## What is Service Discovery?

In the previous parts we created a frontend webpage that display/modify data by communicating with a backend service. But how does the frontend know where and which backend service to reach out to? How does two services connect with each other?

The simplest way to connect each services is to give them each IP addresses of each other. For instance, the frontend is given the address of the backend, and the backend is given the address of the database.

Like this:

![simple structure](images/simple_service_structure.jpeg)

However, this structure raises a couple questions:
- What happens if we want more than 1 frontend and 1 backend services? How do we connect them together then?
- What happens if we one of the backend services is down and we need to redeploy it, do we have to change the address in all our frontend code as well?

Moreover as we scale, we want to be able to add and remove services dynamically depending on the load. For instance, we want to have 3 backend services and 2 frontend services at peak traffic, and only 1 frontend and backend services at normal load. This raises another question:
- How do we balance traffic between services so that they receive a equal amount of work?

![why](images/why_service_discovery.png)

This is where Service Discovery comes in. Service Discovery allows services to determine locations of other available service instances and load balancing requests across them. 

When a client needs to talk to a service, it first queries a service registry, which is a database of available service instances. The client then uses a load‑balancing algorithm to select one of the available service instances and makes a request.

![structure](images/service_discovery_structure.png)

## Introduction

In this part we will be building a Client-side service discovery structure using Redis as the service registry.

## Step 1 - Setting up Redis on DO

Create a droplet on DigitalOcean (1gb should be good enough) using the Ubuntu 18.04 image with private networking enabled.

Follow [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04) to install redis on the droplet.

## Step 2 - Create a registry client

There are two core functions as a registry client:
- Register itself to the service registry when the service is up.
- Query the registry for addresses of services that it wants to talk to.

### Register()

Register() registers itself to the Service Registry. This method does 2 things:
- First, it registers itself to the corresponding service set via `SADD serviceName "address"`. A service set is a set of addresses of instances running the service. Then, it registers itself by setting its status to "alive" that expires every 30 seconds via `SET address "alive" EX 30`. **Note: these two steps are wrapped in a [Transaction](https://redis.io/topics/transactions) to ensure data consistency.**
- Second, it needs to re-register itself every 30 seconds via `SET ...` (in the background) to the registry to *prove* that this service is still alive. If the registry does not hear back from this service within this time period, it will be declared *dead*.

This is what happens in Redis,

```
# An instance running Service A registers itself.
SADD serviceA "10.10.10.11:4567"
SET 10.10.10.11:4567 "alive" EX 30 

# Another instance running Service A registers itself.
SADD serviceA "45.21.34.12:4567"
SET 45.21.34.12:4567 "alive" EX 30
```

### Service()

Service() returns the address of an instance running a given service. Internally, the client first asks for the list of instances running a particular service. Then, it picks one of the instances (ip addresses) using a load balancing strategy. Before returning the address, it checks if the address is still *alive* via `EXISTS ...`. If it is alive, return the address. Otherwise, picks another address.

This is what happens in Redis,

```
# Lookup instances running serviceA.
SMEMBERS serviceA
1) "10.10.10.3:4567"
2) "10.10.10.1:4567"
3) "10.10.10.2:4567"

# Pick an instance and checks if it is alive.
EXISTS 10.10.10.1:4567
(integer) 1   # it is alive!!
```

As for the load balancing strategy, you are free to implement anything you want: [resource](https://www.nginx.com/resources/glossary/load-balancing/)

## Step 3 - Integrate to existing services

Now that you have a working registry client, it is time to put it to use.

- Replace all environment variables lookups with `client.service(...)`
  - For instance: `client.service('backend-service')` will return `10.10.10.3:4567`
- Register itself on every service with `client.register(...)`
  - For instance: `client.register('backend-service', '10.10.10.3', 4567)`

### **Now your cloud architecture is running with service discovery!!** 🎉