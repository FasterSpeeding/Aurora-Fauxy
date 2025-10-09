mise upgrade --yes
ujust update
fwupdmgr refresh --force

exit_code=0
fwupdmgr get-updates || exit_code=$?

# fwupdmgr get-updates returns 2 for commands which passed without any action.
if [[ "$exit_code" -qt 0 && "$exit_code" -ne 2 ]]
then
    echo "`fwupdmgr get-updates` exited with fail code $exit_code"
    exit "$exit_code"
fi


fwupdmgr update
