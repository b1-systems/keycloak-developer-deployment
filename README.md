# Keycloak Developer Deployment

## Overview

This is a highly automated deployment of PostgreSQL, Keycloak and a custom user
storage extension for training and development purposes.

This deployment is used for interactive development and testing of the demo
extension "custom-ipa-user-storage":
* <https://github.com/b1-systems/custom-jpa-user-storage>

## Docker Compose Setup

This project offers a Docker compose deployment with the following services:

* "postgres":  
  PostgreSQL server, configured for prepared transactions (required by Keycloak's XA transactions)
  - database "keycloak" set up empty, ready for Keycloak installation
  - local folder [sql](sql) mounted, every contained file will be processed during initialization

* "keycloak":  
  - using container image "keycloak-custom" built from folder
  [keycloak-custom](keycloak-custom)
  - started in development mode

* "keycloak-test":  
  - only started when selecting compose profile "test"
  - using container image "keycloak-test" built from folder
  [keycloak-test](keycloak-test)
  - executes test procedures using `kcadm.sh`

## Support for (vs)codium

This project includes a workspace definition for [vscodium](https://github.com/VSCodium/vscodium):
* [keycloak-development.code-workspace](keycloak-development.code-workspace) .

*Note:* To utilize codium effectively, the following extension should be installed:

```shell
for extension in \
    docker.docker \
    ms-azuretools.vscode-containers \
    oracle.oracle-java \
    redhat.vscode-yaml \
    vscjava.vscode-maven
do
    codium --install-extension "$extension"
done
```

## Usage

### 1. Install required Software:

```shell
sudo apt install \
  docker.io \
  docker-compose \
  maven \
  openjdk-25-jdk-headless
```

### 2. Clone Repositories for Keycloak Extension Development

```shell
git clone https://github.com/b1-systems/custom-jpa-user-storage.git
git clone https://github.com/b1-systems/keycloak-developer-deployment.git
```

### 3. Build Custom Extension

```shell
mvn -f custom-jpa-user-storage clean package
```

*Note:* This will also deploy the following files to the developer deployment:

- `userdb.sql` to folder `./sql`
- `custom-jpa-user-storage.jar` to folder `./keycloak-custom/providers`
- `keycloak.conf.example` to folder `./keycloak-custom/conf/keycloak.conf`


### 4. Build Customized Container Images

This will build the following container images:

* `keycloak-custom`: customized keycloak OCI that runs service "keycloak"
* `keycloak-test` customized keycloak images that executes test procedures using `kcadm.sh` if compose profile "test" is selected

```shell
docker compose -f keycloak-developer-deployment/compose.yml build
docker compose --profile test -f keycloak-developer-deployment/compose.yml build
```

### 5. Run Deployment

```shell
docker compose -f keycloak-developer-deployment/compose.yml up
```

### 6. Execute Tests

Service `keycloak-test` from compose profile `test` will execute the following tests:

* 'custom-jpa-user-storage':
  - Create user federation using custom provider
  - Determine if expected test user is present
  - Define custom user profile attribute
  - Determine if attribute value of test user matches expected value

```shell
docker compose -f keycloak-developer-deployment/compose.yml --profile test up
```
