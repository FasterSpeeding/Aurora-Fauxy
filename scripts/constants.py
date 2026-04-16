import pathlib


BASE_DIR = pathlib.Path(pathlib.Path(__file__).parent.parent)
SKEL_PATH = pathlib.Path("/etc") / "skel"

CHEZMOI_CACHE_PATH = SKEL_PATH / ".cache" / "chezmoi"
FX_RPM_PATH = SKEL_PATH / ".local" / "state" / "dotfiles" / "fx_cast_bridge.rpm"
SKEL_CHEZMOI_PATH = SKEL_PATH / ".local" / "share" / "chezmoi"
