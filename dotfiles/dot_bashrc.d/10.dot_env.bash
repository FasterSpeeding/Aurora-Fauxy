# Disable ublue's .bling as the dotfiles already do the equivalent.
export BLING_SOURCED=1
export DEV_CONTAINER_IMAGE="ghcr.io/fasterspeeding/devcontainer:master"
export DOTFILES_REPO="git@github.com:FasterSpeeding/dotfiles.git"
export DOTFILE_SERVICES="${DOTFILE_SERVICES:-},fx_cast"
