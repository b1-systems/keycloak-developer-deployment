FROM registry.access.redhat.com/ubi9 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
RUN dnf install --installroot /mnt/rootfs jq --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all && \
    rpm --root /mnt/rootfs -e --nodeps setup

FROM quay.io/keycloak/keycloak
COPY --from=ubi-micro-build /mnt/rootfs /
RUN mkdir /results
RUN chown keycloak:keycloak /results
COPY tests /tests
ENTRYPOINT /tests/index.sh
