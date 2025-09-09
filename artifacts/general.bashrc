function startdev() {
  local base=ghcr.io/fasterspeeding/devcontainer:master
  local target=${1?Pass the container as the first argument}
  shift 1
  devpod up --git-clone-recursive-submodules --fallback-image "$base" "$target" "$@"
}

function jjust() {
  just --justfile /etc/fauxy.justfile "${@}"
}

eval "$(mise activate bash)"

