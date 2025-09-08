FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:a97d7af8b53883e925b33696f30ff56970dbc758bd681c1755d14c7a0461c226 

RUN --mount=type=bind,source=/,target=/ctx,readonly \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    pushd /ctx && \
    bash ./build.bash && \
    popd && \
    dnf5 clean all && \
    ostree container commit

RUN bootc container lint
