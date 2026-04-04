FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@sha256:c3262921bdf31aa8d90b463e6307783693a8787b7b7c55e7945d521b56704908

ENV FX_CAST_VERSION="0.3.0"

RUN --mount=type=bind,source=/,target=/ctx,readonly \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    pushd /ctx && \
    bash ./build.bash && \
    bash ./cleanup.bash && \ 
    popd && \
    ostree container commit

RUN bootc container lint --fatal-warnings --no-truncate
