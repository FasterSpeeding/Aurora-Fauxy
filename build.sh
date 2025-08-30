# Setup fx_cast bridge
temp_dir=$(mktemp -d)

wget https://github.com/hensm/fx_cast/releases/download/v0.3.0/fx_cast_bridge-0.3.0-x64.rpm -o $temp_dir/fx_cast_bridge.rpm

dnf5 install -y $temp_dir/fx_cast_bridge.rpm

rm -rvf "$temp_dir"

useradd --system fx_cast
cp ./artifacts/fx_cast.service /etc/systemd/system/fx_cast.service
systemctl enable fx_cast

# Setup Waydroid

dnf5 install -y waydroid
