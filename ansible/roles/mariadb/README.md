# Ansible Role: MariaDB

Installs and configures MariaDB along with databases and database users.

When installing MariaDB a root user is created with no password, but who can
only login from localhost when running mysql client as root. E.g. to login as
root simply run `sudo mysql`.

## Creating Databases

There are 3 ways to create databases. Either adding them to the databases list
or adding them to the databases list in the drupal_sites or custom_sites list.

**All databases are created on all database servers.** This means that databases
only needed in the dev environment are also created in the live environment.
This is a bug which currently doesn't have a simple solution.

## Database tuning

Some basic tuning is done depending on the group the database server is in. All
database servers should be in the db group, but servers in the db_only group are
treated as dedicated database servers and configured as such.

For details see the main server config file [50-server.cnf.j2](templates/50-server.cnf.j2)

## To Do

 - Create users with each site that can only access that site's databases.
 - Don't create databases on servers where the site isn't needed. This is harder
   than it sounds because there's currently no way to determine if a site needs
   a database on the DB server due to sites being categorised by which app
   server they are on.

## Role Variables

Also see [defaults/main.yml](defaults/main.yml)

### List of databases to create

```
databases: []
```

### List of database users to create.
These users have permissions to connect from anywhere.

```
database_users: []
```

### List of hosts users can connect from

```
database_hosts:
  - '%'
```

### Bind address

Address the database server shopuld bind to. Defaults to * meaning it's
publically accessible.

```
database_bind_address: *
```
