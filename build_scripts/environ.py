import os
import pathlib


FX_CAST_VERSION = os.environ["FX_CAST_VERSION"]

ARTIFACTS_PATH = pathlib.Path(os.environ["AURORA_ARTIFACTS"])
BASE_DIR = pathlib.Path(os.environ["BASE_DIR"])
SYMLINK_TRACKER_PATH = pathlib.Path(os.environ["SYMLINK_TRACKER"])
