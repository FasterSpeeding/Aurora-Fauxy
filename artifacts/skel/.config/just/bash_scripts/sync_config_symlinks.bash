jq -c --raw-output0 '.links[] | [.absolute, .symlink] | flatten | .[]' "$SYMLINK_TRACKER" | xargs -0 -n2 ln -fsv
