from collections import abc as collections
import pathlib
import subprocess
import os

import environ


def call_subprocess(
    *args: str,
    cwd: pathlib.Path = environ.BASE_DIR,
    extra_env: collections.Mapping[str, str] | None = None,
) -> None:
    env = None
    if extra_env:
        env = os.environ.copy()
        env.update(extra_env)

    print(f"Executing command: {' '.join(args)}")
    subprocess.run(args, cwd=cwd, check=True, env=env)


def systemd_enable(name: str, /) -> None:
    call_subprocess(
        "systemctl", "enable", f"{environ.ARTIFACTS_PATH}/systemd/system/{name}.service"
    )
