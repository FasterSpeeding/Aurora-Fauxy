import dataclasses
import pathlib
import shutil
import json
from collections import abc as collections
import environ


@dataclasses.dataclass(frozen=True, kw_only=True, slots=True)
class _Symlink:
    path: pathlib.Path
    symlinked_to: pathlib.Path


@dataclasses.dataclass(frozen=True, kw_only=True, slots=True)
class _TrackedDir:
    path: pathlib.Path
    contents: list[str]


@dataclasses.dataclass(slots=True)
class SymLinker:
    tracked_dirs: list[_TrackedDir] = dataclasses.field(
        init=False, default_factory=list
    )
    tracked_files: list[_Symlink] = dataclasses.field(init=False, default_factory=list)

    def link(self, symlink_to: pathlib.Path | str, path: pathlib.Path | str, /) -> None:
        path = pathlib.Path(path).absolute()
        symlink_to = pathlib.Path(symlink_to).absolute()

        print(f"Creating symlink {path} -> {symlink_to}")
        path.symlink_to(symlink_to)
        self.tracked_files.append(_Symlink(path=path, symlinked_to=symlink_to))

    def _visit_dir(
        self, target_dir: pathlib.Path | str, contents: list[str], /
    ) -> collections.Iterable[str]:
        target_dir = pathlib.Path(target_dir).absolute()

        print(f"Ensuring {target_dir} directory exists")
        self.tracked_dirs.append(_TrackedDir(path=target_dir, contents=contents))
        return ()

    def link_tree(self, source_dir: pathlib.Path, target_dir: pathlib.Path, /) -> None:
        shutil.copytree(
            str(source_dir),
            str(target_dir),
            copy_function=self.link,
            dirs_exist_ok=True,
            ignore=self._visit_dir,
        )

    def save_to_tracker(self) -> None:
        data = dataclasses.asdict(self)
        environ.SYMLINK_TRACKER_PATH.unlink(missing_ok=True)
        with environ.SYMLINK_TRACKER_PATH.open("w") as file:
            json.dump(data, file)


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
