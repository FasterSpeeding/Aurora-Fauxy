# Internal function used for executing bash script tasks
[script]
execute-bash-script script-name *FLAGS:
    path="{{ source_directory() }}/{{ script-name }}.bash"

    if [[ -n "$JUST_TASKS_VERBOSE" ]]
    then
        echo "Execution bash script at $path"
    fi

    bash -eu "$path" {{ FLAGS }}

# Install the default applications and libraries
[script]
install-defaults:
    just execute-bash-script install_defaults

# Update the OS and installed dependencies.
[script]
update:
    just execute-bash-script update
