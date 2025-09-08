FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:052ce27990ac5e6464a6e2679b564702581ea5640247a0479b35b936f84e74c5 

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
