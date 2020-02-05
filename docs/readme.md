# Service API instructions

In this exercise, we will create a multi-server architecture for making a simple app for creating and retrieving a list of users from the database!

## Flow

![flow](https://static.swimlanes.io/e86bed77d0258067e318c30e9f2c52fa.png)

## Architecture

- Sinatra Frontend (1 Droplet)
  - Responsible for asking the Service API for the list of users, and render a html for it.
- Sinatra Service API (1 Droplet)
  - Responsible for talking to Postgres
- Postgres DB (1 Database)

## Prerequisites

- DigitalOcean account
  - Signup and get an API key: https://cloud.digitalocean.com/account/api/ -> "Generate New Token"
- SSH key on DigitalOcean
  - Go on: https://cloud.digitalocean.com/account/security and add your "SSH Key" following the instructions on the site, **and write down your "fingerprint"**
- DO command line tool `doctl`
  - Install: https://github.com/digitalocean/doctl#installing-doctl

## Create Resources on DigitalOcean

To create a droplet for Frontend named: "frontend-sinatra", replace `$fingerprint` below with your "fingerprint", and run this command:

```bash
doctl compute droplet create frontend-sinatra --size s-1vcpu-1gb --image ubuntu-18-04-x64 --region nyc3 --ssh-keys $fingerprint --enable-private-networking
```

You should see something like this:

```bash
ID           Name                Public IPv4    Private IPv4    Public IPv6    Memory    VCPUs    Disk    Region    Image                       Status    Tags    Features    Volumes
178741332    frontend-sinatra                                                  1024      1        25      nyc3      Ubuntu 18.04.3 (LTS) x64    new
```

Do the same for the Service API droplet:

```bash
doctl compute droplet create service-api-sinatra --size s-1vcpu-1gb --image ubuntu-18-04-x64 --region nyc3 --ssh-keys $fingerprint --enable-private-networking
```

Now you should have 2 droplets created:

```bash
> doctl compute droplet list
ID           Name                   Public IPv4        Private IPv4      Public IPv6    Memory    VCPUs    Disk    Region    Image                       Status    Tags    Features              Volumes
178741332    frontend-sinatra       165.227.117.206    10.132.199.188                   1024      1        25      nyc3      Ubuntu 18.04.3 (LTS) x64    active            private_networking
178741737    service-api-sinatra    138.197.75.224     10.132.17.75                     1024      1        25      nyc3      Ubuntu 18.04.3 (LTS) x64    new               private_networking
```

## Setup the droplets for running Sinatra

SSH into your droplet (replace `$droplet_id` with the droplet id from `doctl compute droplet list`)

```bash
doctl compute ssh $droplet_id
```

Install Ruby 2.6.5

```bash
chmod +x setup-ruby.sh && ./setup-ruby.sh
```

Do this for both droplets.

## Setup database on DigitalOcean

Now you need a Postgres database:

```bash
doctl database create postgres-sinatra --engine pg --region nyc3 --size db-s-1vcpu-1gb --version 11 --num-nodes 1
```

*This step might takes a while to run...*

You should see something like this:

```bash
ID                                      Name                      Engine    Version    Number of Nodes    Region    Status      Size
bd0e7e9f-01ba-40cf-a48f-defbdde78560    postgres-sinatra          pg        11         1                  nyc3      creating    db-s-1vcpu-1gb
```

## Setup the connections between your droplets and database

Go on https://cloud.digitalocean.com/databases and click on the database you just created ("postgres-sinatra")

![dashboard](images/db_dashboard.png)

Click on "Add trusted sources" and select the two droplets, plus your laptop's ip.

![add trusted sources](images/db_add_trusted_source.png)

Then click "Allow these inbound sources only".

Now you should be able to access your database from your droplets and your laptop!

## Connect to database from your laptop

Click "Connection details" then "Flags" to see the commands for connecting using `psql`

![connection details](images/db_connection_details.png)

Run that command in terminal and you should be able to connect to the database.

### **Now your cloud architecture is all ready to go!** 🎉