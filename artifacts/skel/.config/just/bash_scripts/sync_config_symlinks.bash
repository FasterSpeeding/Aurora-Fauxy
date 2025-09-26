while read -r -d $'\0' absolute; read -r -d $'\0' symlink
do
    if [[ "$absolute" == /etc/skel* ]]
    then
      sym_dir=$(dirname "$symlink")

      mkdir -vp "$sym_dir"
      ln -sf "$absolute" "$symlink"
    fi
done < <(jq -c --raw-output0 '.links[] | [.absolute, .symlink] | flatten | .[]' "$SYMLINK_TRACKER")
