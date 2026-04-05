import pathlib
import shutil

import cli_calls
import exceptions


_DIRS_TO_DELETE = [pathlib.Path("/var/lib/dnf"), pathlib.Path("/var/lib/waydroid")]


def main() -> None:
    for path in _DIRS_TO_DELETE:
        if path.is_dir():
            print(f"Removing directory {path!s}")
            shutil.rmtree(str(path))

        elif path.exists():
            message = f"Unexpected file/symlink found at {path!s}, expected a directory"
            raise exceptions.ExpectedError(message)

    cli_calls.call_subprocess("dnf5", "clean", "all")


if __name__ == "__main__":
    with exceptions.ExpectedError.catch():
        main()
