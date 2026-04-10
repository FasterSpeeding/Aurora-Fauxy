import pathlib
import shutil
from collections import abc as collections


def _copy(source: str, target: str) -> None:
    print(f"Copying {source} -> {target}")
    shutil.copy2(source, target)


def _visit_folder(path: str, _: list[str], /) -> collections.Iterable[str]:
    print(f"Ensuring {path} directory")
    return ()


def copy_tree(
    source: pathlib.Path, target: pathlib.Path, /, *, merge: bool = False
) -> None:
    shutil.copytree(
        str(source.absolute()),
        str(target.absolute()),
        copy_function=_copy,
        ignore=_visit_folder,
        dirs_exist_ok=merge,
    )
