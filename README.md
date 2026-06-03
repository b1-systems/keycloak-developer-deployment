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

1. Install required software:

```shell
sudo apt install \
  docker.io \
  docker-compose \
  maven \
  openjdk-25-jdk-headless
```

2. Clone repositories for Keycloak extension development:

```shell
git clone https://github.com/b1-systems/custom-jpa-user-storage.git
git clone https://github.com/b1-systems/keycloak-developer-deployment.git
```

3. Build custom extension:

```shell
mvn -f custom-jpa-user-storage clean package
```

*Note:* This will also deploy the following files to the developer deployment:

- `userdb.sql` to folder `./sql`
- `custom-jpa-user-storage.jar` to folder `./keycloak-custom/providers`
- `keycloak.conf.example` to folder `./keycloak-custom/conf/keycloak.conf`

4. Build customized Keycloak container image:

```shell
docker compose -f keycloak-developer-deployment/compose.yml build
```

5. Run deployment:

```shell
docker compose -f keycloak-developer-deployment/compose.yml up
```

6. Execute tests running additional service `keycloak-test` from compose profile `test`:

This will execute the following tests:

  * 'custom-jpa-user-storage':
    - Create user federation using custom provider
    - Determine if expected test user is present
    - Define custom user profile attribute
    - Determine if attribute value of test user matches expected value

```shell
docker compose -f keycloak-developer-deployment/compose.yml --profile test up
```
