import enum
import platform
import os
import pathlib

import exceptions
from typing import Self


class FxArchs(str, enum.Enum):
    ARM64 = "arm64"
    AARCH64 = ARM64
    X64 = "x64"
    X86_64 = X64

    @classmethod
    def from_os(cls) -> Self:
        try:
            return cls[platform.machine().upper()]

        except KeyError:
            message = f"Unexpected architecture found: {platform.machine()}"
            raise exceptions.ExpectedError(message) from None


BASE_DIR = pathlib.Path(pathlib.Path(__file__).parent)
DOTFILES_REPO = os.environ["DOTFILES_REPO"]
FX_RPM_REL_PATH = ".local/state/dotfiles/fx_cast_bridge.rpm"

CHEZMOI_CACHE_PATH = pathlib.Path(os.environ["CHEZMOI_CACHE"])
SKEL_PATH = pathlib.Path("/etc") / "skel"
