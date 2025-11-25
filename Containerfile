FROM ghcr.io/ublue-os/aurora-dx-nvidia-open:stable@sha256:c5b3fe6b4a5f8a59740ec19452866a3800692d0329989e557e711c33e541940e

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
