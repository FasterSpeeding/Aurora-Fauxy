while read -r -d $'\0' absolute; read -r -d $'\0' symlink
do
    ln -sf "$absolute" "$symlink"
done < <(jq -c --raw-output0 '.links| map(.absolute, .symlink) | flatten | .[]' "$SYMLINK_TRACKER")
