import exceptions
import constants

import cli_calls


def main() -> None:
    print("Running build tasks")
    fx_arch = constants.FxArchs.from_os()

    # Install tooling.

    cli_calls.call_subprocess("dnf5", "copr", "enable", "jdxcode/mise", "-y")
    cli_calls.call_subprocess(
        "dnf5", "install", "-y", "mangohud", "mise", "screen", "waydroid"
    )

    # Initialise dotfiles in the skeleton directory
    cli_calls.call_subprocess(
        "mise",
        "exec",
        "chezmoi",
        "--",
        "chezmoi",
        "init",
        "--apply",
        constants.DOTFILES_REPO,
        "--destination",
        str(constants.SKEL_PATH),
        "--cache",
        str(constants.CHEZMOI_CACHE_PATH),
        extra_env={
            "DOTFILE_SERVICES": constants.DOTFILE_SERVICES,
            "FX_ARCH": fx_arch.value,
            "FX_RPM_REL_PATH": constants.FX_RPM_REL_PATH,
        },
    )

    # Post-sync installs.
    cli_calls.call_subprocess(
        "dnf5", "install", "-y", str(constants.SKEL_PATH / constants.FX_RPM_REL_PATH)
    )


if __name__ == "__main__":
    with exceptions.ExpectedError.catch():
        main()
