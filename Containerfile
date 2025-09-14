FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:120599599bb5d5205681e4f2e3feeac901e1598e0a8faee2e3a7ab4a45b6b0ae 

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
