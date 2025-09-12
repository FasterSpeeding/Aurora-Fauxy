set -ouex pipefail

FX_CAST_VERSION="0.3.0"
arch=$(uname -m)

if [[ "$arch" == "aarch64" ]]; then
    arch="arm64"
elif [[ "$arch" == "x86_64" ]]; then
    arch="x64"
fi

# Setup fx_cast bridge
temp_dir=$(mktemp -d)
pushd "$temp_dir"

# Temporarily alias /opt to /usr/sbin instead of /var/opt which doesn't exist yet.
mv /opt /opt2
ln -s /usr/sbin /opt

wget https://github.com/hensm/fx_cast/releases/download/v$FX_CAST_VERSION/fx_cast_bridge-$FX_CAST_VERSION-$arch.rpm -O ./fx_cast_bridge.rpm
dnf5 install -y ./fx_cast_bridge.rpm

popd
rm -rvf "$temp_dir"

# Undo /opt changes
rm /opt
mv /opt2 /opt

cp ./artifacts/systemd_services/* /etc/systemd/system/
systemctl enable create_fx_cast_user
systemctl enable fx_cast

# Setup Waydroid

dnf5 install -y waydroid

# Setup mise

dnf copr enable jdxcode/mise -y
dnf install mise -y

mkdir --parents /etc/mise
cp ./artifacts/mise.toml /etc/mise/config.toml

# Configure environment

cp ./artifacts/justfile /etc/fauxy.justfile
cat ./artifacts/general.bashrc >> /etc/bashrc
