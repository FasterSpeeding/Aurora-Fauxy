krew_path="${KREW_ROOT:-$HOME/.krew}/bin"

if [[ -d "$krew_path" ]]
then
  export PATH="$krew_path:$PATH"
fi
