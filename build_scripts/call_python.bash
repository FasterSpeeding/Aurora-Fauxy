set -eu

export BASE_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../")"
file_name="$1"

source "$BASE_DIR/artifacts/bashrc/1.env.bash"

python "$BASE_DIR/build_scripts/$file_name.py"
