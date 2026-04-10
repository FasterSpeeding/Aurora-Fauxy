import pathlib
import shutil

import cli_calls
import exceptions


_DIRS_TO_DELETE = [pathlib.Path("/var/lib/dnf"), pathlib.Path("/var/lib/waydroid")]


def main() -> None:
    print("Running cleanup tasks")

    for path in _DIRS_TO_DELETE:
        if path.is_dir():
            print(f"Removing directory {path!s}")
            shutil.rmtree(str(path))

        elif not path.exists():
            print(f"Skipping {path!s} directory cleanup, does not exist!")

        else:
            message = f"Unexpected file/symlink found at {path!s}, expected a directory"
            raise exceptions.ExpectedError(message)

    cli_calls.call_subprocess("dnf5", "clean", "all")
    cli_calls.call_subprocess("mise", "prune", "-y")
    cli_calls.call_subprocess("mise", "cache", "clear", "-y")


if __name__ == "__main__":
    with exceptions.ExpectedError.catch():
        main()
