jq -c --raw-output0 '.dirs[]' "$SYMLINK_TRACKER" | xargs -0 -I {} mkdir -vp {}
jq -c --raw-output0 '.links[] | [.symlink, .absolute] | flatten | .[]' "$SYMLINK_TRACKER" | xargs -0 -n2 ln -fsv
