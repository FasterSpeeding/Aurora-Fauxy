FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@ sha256:35086ae7811d92d014c65730dc22bf2ffcc37e7c31d7783f1d874be2b51ee081

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
