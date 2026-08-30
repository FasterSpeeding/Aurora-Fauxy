FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable

ENV FX_CAST_VERSION="0.3.0"

RUN --mount=type=bind,source=/,target=/ctx,readonly \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    pushd /ctx && \
    bash ./build_scripts/call_python.bash build && \
    bash ./build_scripts/call_python.bash cleanup && \
    popd && \
    ostree container commit

RUN bootc container lint --fatal-warnings --no-truncate
