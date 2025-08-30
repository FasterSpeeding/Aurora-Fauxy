set -eu

FX_CAST_VERSION="0.3.0"
arch=$(uname -m)

if [[ "$arch" == "aarch64" ]]; then
    arch="arm64"
elif [[ "$arch" == "x86_64" ]]; then
    arch="x64"
fi

# Setup fx_cast bridge
temp_dir=$(mktemp -d)

wget https://github.com/hensm/fx_cast/releases/download/v$FX_CAST_VERSION/fx_cast_bridge-$FX_CAST_VERSION-$arch.rpm -O $temp_dir/fx_cast_bridge.rpm

dnf5 install -y $temp_dir/fx_cast_bridge.rpm

rm -rvf "$temp_dir"

useradd --system fx_cast
cp ./artifacts/fx_cast.service /etc/systemd/system/fx_cast.service
systemctl enable fx_cast

# Setup Waydroid

dnf5 install -y waydroid
