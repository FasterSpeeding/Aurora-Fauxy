FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:031224912459db7247062d05c536b3c307e0bcee98dde4f36b9dd06a119cd45d 

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
