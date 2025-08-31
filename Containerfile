FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:99afd1d585814043018fb243e1f774825d9a720cf7e317daccf66e528fe4f5ba 

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
