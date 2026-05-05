FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@sha256:a82a26e37b17cd80ed1f035f59078499cb81beccf3cb4812b2af157a389a0e38

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
