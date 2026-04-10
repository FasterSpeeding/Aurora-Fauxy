import pathlib
import exceptions
import environ

import linking
import cli_calls
import fx_cast


BLING_PATH = pathlib.Path("/usr") / "share" / "ublue-os" / "bling" / "bling.sh"
SKEL_PATH = pathlib.Path("/etc") / "skel"


def main() -> None:
    print("Running build tasks")

    # Copy artifacts
    linking.copy_tree(environ.BASE_DIR / "artifacts", environ.ARTIFACTS_PATH)

    # Install tooling.

    fx_cast.install_fx_cast_bridge()

    cli_calls.call_subprocess("dnf5", "copr", "enable", "jdxcode/mise", "-y")

    cli_calls.call_subprocess(
        "dnf5", "install", "-y", "mangohud", "mise", "screen", "waydroid"
    )

    # Override bling.sh from Project bluefin's common config to fix bash-preexec and Atuin integration.
    print(f"Overriding {BLING_PATH} to fix bash-preexec and atuin")
    (environ.ARTIFACTS_PATH / "bling.sh").copy(BLING_PATH)

    # Initialise dotfiles in the skeleton directory
    # TODO: disable cache, check if source path is working properly
    cli_calls.call_subprocess(
        "mise",
        "exec",
        "chezmoi",
        "--",
        "chezmoi",
        "init",
        "--apply",
        environ.DOTFILES_REPO,
        "--destination",
        str(SKEL_PATH),
    )


if __name__ == "__main__":
    with exceptions.ExpectedError.catch():
        main()
