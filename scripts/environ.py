import os
import pathlib


ARTIFACTS_PATH = pathlib.Path(os.environ["AURORA_ARTIFACTS"])
BASE_DIR = pathlib.Path(os.environ["BASE_DIR"])
DOTFILES_REPO = os.environ["DOTFILES_REPO"]
FX_CAST_VERSION = os.environ["FX_CAST_VERSION"]
