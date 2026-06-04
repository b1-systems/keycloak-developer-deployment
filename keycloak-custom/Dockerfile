##
# Builder

ARG KEYCLOAK_VERSION=26.6.2

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

# Add all providers deployed by the custom-* extensions
COPY --chown=keycloak:keycloak --chmod=644 providers/*.jar /opt/keycloak/providers/

# Add common portion of keycloak.conf
COPY --chown=keycloak:keycloak --chmod=644 conf/keycloak.conf /opt/keycloak/conf/keycloak.conf

# Append per-test-portions of keycloak.conf
RUN mkdir  /opt/keycloak/conf/keycloak.conf.d
COPY --chown=keycloak:keycloak --chmod=644 conf/keycloak.conf.d /opt/keycloak/conf/keycloak.conf.d
RUN bash -c "cat /opt/keycloak/conf/keycloak.conf.d/*.conf >> /opt/keycloak/conf/keycloak.conf"
RUN chown keycloak:keycloak /opt/keycloak/conf/keycloak.conf
RUN rm -rf /opt/keycloak/conf/keycloak.conf.d

# Pre-build Keycloak
RUN /opt/keycloak/bin/kc.sh build
RUN rmdir /opt/keycloak/data/tmp

##
# Container

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/
