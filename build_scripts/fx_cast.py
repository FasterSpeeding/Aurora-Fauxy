import exceptions
import subprocess
import enum
import platform
import pathlib
import environ
import cli_calls
import urllib.request
import shutil


RPM_STORE_PATH = environ.ARTIFACTS_PATH / "rpms"
OPT_PATH = pathlib.Path("/opt")


class FxArchs(str, enum.Enum):
    ARM64 = "arm64"
    AARCH64 = ARM64
    X64 = "x64"
    X86_64 = X64


def install_fx_cast_bridge() -> None:
    RPM_STORE_PATH.mkdir(exist_ok=True)

    temp_opt = OPT_PATH.rename("/temp_opt")

    try:
        OPT_PATH.mkdir()

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
        shutil.rmtree(OPT_PATH)
        temp_opt.rename(OPT_PATH)
