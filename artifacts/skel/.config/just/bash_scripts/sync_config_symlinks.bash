while read -r -d $'\0' absolute; read -r -d $'\0' symlink
do
    if [[ "$symlink" == /etc/skel* ]]
    then
      symlink="$HOME/${symlink#/etc/skel/}"
      sym_dir=$(dirname "$symlink")

      mkdir -vp "$sym_dir"
      ln -sfv "$absolute" "$symlink"
    fi
done < <(jq -c --raw-output0 '.links[] | [.absolute, .symlink] | flatten | .[]' "$SYMLINK_TRACKER")
