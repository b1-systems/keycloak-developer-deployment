# Keycloak Developer Deployment

## Overview

This project provides a "semi-automated" deployment, based on Docker compose,
of PostgreSQL, Keycloak and custom extensions for Keycloak. It is primarily
intended for training and development purposes.

See also:

* <https://github.com/b1-systems/custom-auth-spi>
* <https://github.com/b1-systems/custom-jpa-user-storage>
* <https://github.com/b1-systems/custom-ldap-enabled-mapper>

## Docker Compose Setup

This project offers a Docker compose deployment with the following services:

* "postgres":  
  - database "keycloak" set up empty, ready for installation
  - local folder [sql](sql) mounted, every contained file will be processed during initialization

* "keycloak":  
  - launches Keycloak in development mode on port 8080/tcp (HTTP)
  - container image "keycloak-custom" built from folder [keycloak-custom](keycloak-custom)

* "keycloak-test":  
  - started by compose profile "test"
  - executes test procedures using `kcadm.sh`
  - container image "keycloak-test" built from folder [keycloak-test](keycloak-test)

## Support for VS Code and VSCodium

This project includes a workspace definition for [vscodium](https://github.com/VSCodium/vscodium):
* [keycloak-development.code-workspace](keycloak-development.code-workspace) .

*Note:* To run the pre-defined build tasks, the following extension should be installed:

```shell
for extension in \
    ms-azuretools.vscode-containers \
    oracle.oracle-java \
    vscjava.vscode-maven
do
    codium --install-extension "$extension"
done
```

## Usage

### 1. Install required Software:

This developer deployment was tested using Debian GNU/linux 13 with Docker CE
and compose plugin, JDK and Maven as provided by the distribution:

```shell
sudo apt install \
  docker.io \
  docker-compose \
  maven \
  openjdk-25-jdk-headless
```

### 2. Clone Repositories for Keycloak Extension Development

Clone the developer deployment repo:

```shell
git clone https://github.com/b1-systems/keycloak-developer-deployment.git
```

Clone the custom Keycloak extensions:

```shell
git clone https://github.com/b1-systems/custom-auth-spi.git
git clone https://github.com/b1-systems/custom-jpa-user-storage.git
git clone https://github.com/b1-systems/custom-ldap-enabled-mapper.git
# ... other custom extensions, if any.
```

### 3. Build Custom Extensions

```shell
mvn -f custom-auth-spi clean package
mvn -f custom-jpa-user-storage clean package
mvn -f custom-ldap-enabled-mapper clean package
# ... other custom extensions, if any.
```

*Note:* The build tasks of the extensions deploy the following files to the developer deployment:

- JAR files of the custom provider(s) from folder `${extension}/target`
- Custom provider-specific `keycloak.conf` from folder `${extension}/conf`, if any.
- Additional SQL from folder `${extension}/sql`, if any.
- Test scripts from `${extension}/tests`, if any.

These resources will be added to the container images `keycloak-custom` and
`keycloak-test` as necessary.

### 4. Build Customized Container Images

This will build the following container images:

* `keycloak-custom`: customized Keycloak container image that runs
  service "keycloak" for interactive use and testing.

```shell
docker compose -f keycloak-developer-deployment/compose.yml build
```

* `keycloak-test`: customized Keycloak container image that executes
  test procedures using `kcadm.sh`, prints test results and exits
  (run only if the compose profile "test" is selected).

```shell
docker compose --profile test -f keycloak-developer-deployment/compose.yml build
```

### 5. Run Deployment

```shell
docker compose -f keycloak-developer-deployment/compose.yml up
```

### 6. Execute Tests

For example, the service `keycloak-test` from compose profile `test` will
execute the following tests from extension `custom-jpa-user-storage`:

- Create user federation using custom provider
- Determine if expected test user is present
- Define custom user profile attribute
- Determine if attribute value of test user matches expected value

To run all deployed tests:

```shell
docker compose -f keycloak-developer-deployment/compose.yml --profile test up
```

## Author, Copyright and License Information

* Copyright 2026 B1 Systems GmbH &lt;[info@b1-systems.de](mailto:info@b1-systems.de)&gt;

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
