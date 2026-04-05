while read -r -d $'\0' symlinked_to; read -r -d $'\0' path
do
    if [[ "$path" == /etc/skel* ]]
    then
      path="$HOME/${symlink#/etc/skel/}"
      sym_dir=$(dirname "$path")

      mkdir -vp "$sym_dir"
      ln -sfv "$symlinked_to" "$path"
    fi
done < <(jq -c --raw-output0 '.links[] | [.symlinked_to, .path] | flatten | .[]' "$SYMLINK_TRACKER")
