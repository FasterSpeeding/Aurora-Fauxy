import pathlib
import exceptions
import environ

import linking
import cli_calls
import fx_cast


USR_PATH = pathlib.Path("/usr")
ETC_PATH = pathlib.Path("/etc")
BLING_PATH = USR_PATH / "share" / "ublue-os" / "bling" / "bling.sh"


def main() -> None:
    sym_linker = linking.SymLinker()

    print("Running build tasks")

    # Copy artifacts and symlink reference user configs
    linking.copy_tree(environ.BASE_DIR / "artifacts", environ.ARTIFACTS_PATH)
    sym_linker.link_tree(environ.ARTIFACTS_PATH / "skel", ETC_PATH / "skel")
    # sym_linker.link_tree(environ.ARTIFACTS_PATH / "etc", ETC_PATH)

    # Install tooling.

    fx_cast.install_fx_cast_bridge()

    cli_calls.call_subprocess("dnf5", "copr", "enable", "jdxcode/mise", "-y")

    cli_calls.call_subprocess(
        "dnf5", "install", "-y", "mangohud", "mise", "screen", "waydroid"
    )

    # Copy executables to /usr/bin and /usr/sbin

    linking.copy_tree(environ.ARTIFACTS_PATH / "usr" / "bin", USR_PATH / "bin")
    # linking.copy_tree(ARTIFACTS_PATH, "usr", "sbin", USR_PATH / "sbin")

    # Override bling.sh from Project bluefin's common config to fix bash-preexec and Atuin integration.
    print(f"Overriding {BLING_PATH} to fix bash-preexec and atuin")
    (environ.ARTIFACTS_PATH / "bling.sh").copy(BLING_PATH)

    # Save tracked symlinks

    sym_linker.save_to_tracker()


if __name__ == "__main__":
    with exceptions.ExpectedError.catch():
        main()
