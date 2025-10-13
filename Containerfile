FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:a145f99e98841e7db374f4bac24992f8317459b5a4b3c91310b878bc2f2b185d 

ENV FX_CAST_VERSION="0.3.0"

RUN --mount=type=bind,source=/,target=/ctx,readonly \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    pushd /ctx && \
    bash ./build.bash && \
    dnf5 clean all && \
    bash ./cleanup.bash && \ 
    popd && \
    ostree container commit

RUN bootc container lint --fatal-warnings --no-truncate
