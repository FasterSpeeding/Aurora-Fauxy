FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@sha256:ac9604b1dc0316960148f6d3bf0c3d44ce375aa2c63cc4f7578b948cf44e4f6b

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
