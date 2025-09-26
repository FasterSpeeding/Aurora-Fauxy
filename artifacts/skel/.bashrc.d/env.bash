# File synced from https://github.com/FasterSpeeding/Aurora-Fauxy
# Changes will not be persisted

# Set vi as global editor
export EDITOR="$(command -v vi)"

# Path to the aurora artifacts directory
AURORA_ARTIFACTS="/usr/libs/aurora"

# Path to the file used to track the symlinks to sync for Aurora
export SYMLINK_TRACKER="$AURORA_ARTIFACTS/.symlinks"
