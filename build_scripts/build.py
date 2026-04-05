import enum
import platform
import urllib.request
import subprocess
import pathlib
import shutil
import exceptions
import environ

import linking
import cli_calls


USR_PATH = pathlib.Path("/usr")
ETC_PATH = pathlib.Path("/etc")
BLING_PATH = USR_PATH / "share" / "ublue-os" / "bling" / "bling.sh"
RPM_STORE_PATH = environ.ARTIFACTS_PATH / "rpms"

RPM_STORE_PATH.mkdir(exist_ok=True)


class FxArchs(str, enum.Enum):
    ARM64 = "arm64"
    AARCH64 = ARM64
    X64 = "x64"
    X86_64 = X64


def install_fx_cast_bridge() -> None:
    opt = pathlib.Path("/opt")

    temp_opt = opt.rename("/temp_opt")

    try:
        opt.mkdir()

        try:
            arch = FxArchs[platform.machine().upper()].value

        except KeyError:
            message = f"Unexpected architecture found: {platform.machine()}"
            raise exceptions.ExpectedError(message) from None

        url = (
            f"https://github.com/hensm/fx_cast/releases/download/v{environ.FX_CAST_VERSION}"
            f"/fx_cast_bridge-{environ.FX_CAST_VERSION}-{arch}.rpm"
        )
        path = RPM_STORE_PATH / "fx_cast_bridge.rpm"
        path.unlink(missing_ok=True)

        with urllib.request.urlopen(url) as response, path.open("wb") as file:
            shutil.copyfileobj(response, file)

        subprocess.run(["dnf5", "install", "-y", str(path.absolute())], check=True)

        cli_calls.systemd_enable("create_fx_cast_user")
        cli_calls.systemd_enable("fx_cast")

    finally:
        shutil.rmtree(opt)
        temp_opt.rename(opt)


def main() -> None:
    sym_linker = linking.SymLinker()

    # Copy artifacts and symlink reference user configs
    linking.copy_tree(environ.BASE_DIR / "artifacts", environ.ARTIFACTS_PATH)
    sym_linker.link_tree(environ.ARTIFACTS_PATH / "skel", ETC_PATH / "skel")
    sym_linker.link_tree(environ.ARTIFACTS_PATH / "etc", ETC_PATH)

    # Install tooling.

    install_fx_cast_bridge()

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
