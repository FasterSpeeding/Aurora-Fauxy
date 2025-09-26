set -eux

source ./artifacts/skel/.bashrc.d/env.bash

tracked_symlinks='{"dirs":[],"links":[]}'
arch=$(uname -m)

if [[ "$arch" == "aarch64" ]]; then
    arch="arm64"
elif [[ "$arch" == "x86_64" ]]; then
    arch="x64"
else
    echo "Unknown arch: $arch"
    exit 1
fi

# Recursively create tracked absolute symbolic links between two directories
function symlink() {
    source_dir=$1
    target_dir=$2

    find "$source_dir/" -type d -printf "%P\0" | xargs -0 -I {} mkdir -p $target_dir/{}
    while read -r -d $'\0' rel_path
    do
        source_path="$source_dir/$rel_path"
        target_path="$target_dir/$rel_path"

        if [[ -d "$source_path" ]]
        then
            tracked_symlinks=$(echo "$tracked_symlinks" | 
                jq -c --arg path "$target_path" '.dirs += [$path]')

            mkdir -vp "$target_path"
        elif [[ -f "$source_path" ]]
        then
            absolute=$(realpath "$source_path")
            tracked_symlinks=$(echo "$tracked_symlinks" | 
                jq -c \
                --arg abs "$absolute" \
                --arg sym "$target_path" \
                '.links += [{"absolute":$abs,"symlink":$sym}]')

            ln -vs "$absolute" "$target_path"
        else
            echo "Ignoring path $source_path"
        fi
    done < <(find "$source_dir/" -printf "%P\0")
}

function systemd_enable() {
    systemctl enable "$AURORA_ARTIFACTS/systemd/system/$1.service"
}

# Copy artifacts and symlink reference user configs

rsync -rtv ./artifacts/ "$AURORA_ARTIFACTS"

symlink "$AURORA_ARTIFACTS/skel" /etc/skel

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

systemd_enable create_fx_cast_user
systemd_enable fx_cast

# Setup Waydroid

dnf5 install -y waydroid

# Setup mise

dnf copr enable jdxcode/mise -y
dnf install mise -y

# Save tracked symlinks

echo "$tracked_symlinks" >> "$SYMLINK_TRACKER"
