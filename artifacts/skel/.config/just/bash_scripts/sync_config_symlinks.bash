jq -c --raw-output0 '.links[] | [.absolute, .symlink] | flatten | .[]' "$SYMLINK_TRACKER" | xargs -0 -n2 ln -fsv
jq -c --raw-output0 '.dirs[]' "$SYMLINK_TRACKER" | xargs -0 -I {} mkdir -vp {}
