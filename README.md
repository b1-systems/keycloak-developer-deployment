# Keycloak Developer Deployment

## Overview

This is a deployment using Docker compose that launches the following services:

* "postgres":  
  PostgreSQL server, configured for prepared transactions (required by Keycloak's XA transactions)
  - database "keycloak" set up empty, ready for Keycloak installation
  - local folder [sql](sql) mounted, every contained file will be processed during initialization

* "keycloak":  
  - using container image "keycloak-custom" built from folder
  [keycloak-custom](keycloak-custom)
  - started in development mode

## Usage

1. Acquire required repositories:

```shell
cd ${HOME}
git clone https://github.com/b1-systems/custom-jpa-user-storage.git
git clone https://github.com/b1-systems/keycloak-developer-deployment.git
```

2. Build custom extension:

```shell
mvn -f custom-jpa-user-storage clean package
```

*Note:* This will also deploy the following files to the developer deployment:

- `userdb.sql` to folder `./sql`
- `custom-jpa-user-storage.jar` to folder `./keycloak-custom/providers`
- `keycloak.conf.example` to folder `./keycloak-custom/conf/keycloak.conf`

3. Build the customized Keycloak container:

```shell
docker compose -f keycloak-developer-deployment/compose.yml build
```

4. Launch the deployment:

```shell
docker compose -f keycloak-developer-deployment/compose.yml up
```
