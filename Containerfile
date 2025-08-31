FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:2373c34c9ca2f689543e504f39704ed9b9ac68552599200cd5fd7b567369fdc5 

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
