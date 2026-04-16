FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@sha256:f6efc4ae7acc9bdc49cc5304001cb7e5f8600bac81e8ca8323959f684dc2efc9

ENV EXPECTED_USERNAME="lucy"
ENV FX_VER="0.3.0"


RUN --mount=type=bind,source=/,target=/ctx,readonly \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    pushd /ctx && \
    python ./scripts/build.py && \
    python ./scripts/cleanup.py && \
    popd && \
    ostree container commit

RUN bootc container lint --fatal-warnings --no-truncate
