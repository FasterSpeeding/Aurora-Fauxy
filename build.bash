set -ouex pipefail

source ./artifacts/skel/.bashrc.d/env.bash

tracked_symlinks='{"links":[]}'
arch=$(uname -m)

function sync_and_symlink() {
    source_dir=$1
    target_dir=$2
    sym_dir=$3

    rsync -rtv "$source_dir" "$target_dir"

    while read -r -d $'\0' path
    do
        absolute=$(realpath "$target_dir/$path")
        symlink="$sym_dir/$path"
        tracked_symlinks=$(echo "$tracked_symlinks" | 
            jq -c \
            --arg abs "$absolute" \
            --arg sym "$symlink" \
            '.links += {"absolute":$abs,"symlink":$sym}')

        ln -s "$absolute" "$symlink"
    done < <(find "$source_dir" -type f -printf "%P\0")
}

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

sync_and_symlink ./artifacts/systemd/ /usr/lib/systemd/ /etc/systemd/

systemctl enable create_fx_cast_user
systemctl enable fx_cast

# Setup Waydroid

dnf5 install -y waydroid

# Setup mise

dnf copr enable jdxcode/mise -y
dnf install mise -y

mkdir --parents /etc/mise

# Copy reference user config

sync_and_symlink ./artifacts/skel/ /usr/etc/aurora-skel/ /etc/skel/
echo "$tracked_symlinks" >> "$SYMLINK_TRACKER"
