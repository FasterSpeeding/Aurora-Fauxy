FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@sha256:cb868f1b527e2f9fec4777df1aa6fdeccc0e9fa063bdad80a9611d1815df7ad4

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
