# File synced from https://github.com/FasterSpeeding/Aurora-Fauxy
# Changes will not be persisted

# Path to the aurora artifacts directory
export AURORA_ARTIFACTS="/usr/lib/aurora"

# Set vi as global editor
export EDITOR="$(command -v vi)"

# Path to the file used to track the symlinks to sync for Aurora
export SYMLINK_TRACKER="$AURORA_ARTIFACTS/.symlinks"

# Disable telemetry in cargo-binstaller
export BINSTALL_DISABLE_TELEMETRY="true"
