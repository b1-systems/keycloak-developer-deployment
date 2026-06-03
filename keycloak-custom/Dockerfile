ARG KEYCLOAK_VERSION=26.6.2

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

COPY --chown=keycloak:keycloak --chmod=644 providers/custom-jpa-user-storage.jar /opt/keycloak/providers/custom-jpa-user-storage.jar
COPY --chown=keycloak:keycloak --chmod=644 conf/keycloak.conf /opt/keycloak/conf/keycloak.conf

RUN /opt/keycloak/bin/kc.sh build
RUN rmdir /opt/keycloak/data/tmp

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/
