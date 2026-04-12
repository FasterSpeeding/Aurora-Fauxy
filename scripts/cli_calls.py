from collections import abc as collections
import pathlib
import subprocess
import os

import constants


def call_subprocess(
    *args: str,
    cwd: pathlib.Path = constants.BASE_DIR,
    extra_env: collections.Mapping[str, str] | None = None,
) -> None:
    env = None
    if extra_env:
        env = os.environ.copy()
        env.update(extra_env)

    print(f"Executing command: {' '.join(args)}")
    subprocess.run(args, cwd=cwd, check=True, env=env)
