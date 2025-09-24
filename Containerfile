FROM ghcr.io/ublue-os/aurora-dx:stable@sha256:4389f4d42ea375ad20d3f56138529bb602e51fe97158faca44260290fdfaa682 

ENV FX_CAST_VERSION="0.3.0"

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
