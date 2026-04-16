import exceptions
import constants
import shutil

import cli_calls


def main() -> None:
    print("Running build tasks")
    fx_path = str(constants.FX_RPM_PATH.relative_to(constants.SKEL_PATH))

    # Install tooling.

    cli_calls.call_subprocess("dnf5", "copr", "enable", "jdxcode/mise", "-y")
    cli_calls.call_subprocess(
        "dnf5", "install", "-y", "mangohud", "mise", "screen", "waydroid"
    )

    # Initialise dotfiles in the skeleton directory
    shutil.copytree(
        str(constants.BASE_DIR / "dotfiles"), str(constants.SKEL_CHEZMOI_PATH)
    )

    cli_calls.call_subprocess(
        "mise",
        "exec",
        "chezmoi",
        "--",
        "chezmoi",
        "init",
        "--apply",
        "--source",
        str(constants.SKEL_CHEZMOI_PATH),
        "--destination",
        str(constants.SKEL_PATH),
        "--cache",
        str(constants.CHEZMOI_CACHE_PATH),
        extra_env={"FX_RPM_PATH_REL": fx_path},
    )

    # Post-sync installs.
    cli_calls.call_subprocess("dnf5", "install", "-y", fx_path)


if __name__ == "__main__":
    with exceptions.ExpectedError.catch():
        main()
