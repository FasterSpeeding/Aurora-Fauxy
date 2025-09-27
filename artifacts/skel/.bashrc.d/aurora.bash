# File synced from https://github.com/FasterSpeeding/Aurora-Fauxy
# Changes will not be persisted

AURORA_ARTIFACTS="${AURORA_ARTIFACTS:-/usr/lib/aurora}"

bash_artifacts="$AURORA_ARTIFACTS/bashrc"

if [[ -d "$bash_artifacts" ]]
then
    while read -r -d $'\0' path
    do
        if [[ -f "$path" ]]
        then
            . "$path"
        fi
    done < <(find "$bash_artifacts/" -print0)
fi
