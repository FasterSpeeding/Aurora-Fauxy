import types
import contextlib
import sys
from collections import abc as collections


class ExpectedError(RuntimeError):
    message: str

    @classmethod
    def _handle_exception(
        cls,
        _: type[BaseException] | None,
        error: BaseException | None,
        __: types.TracebackType | None,
    ) -> bool | None:
        if error is not None and isinstance(error, cls):
            print(error.message, file=sys.stderr)
            return True

    @classmethod
    def catch(cls) -> contextlib.AbstractContextManager[None]:
        @contextlib.contextmanager
        def context() -> collections.Iterator[None]:
            with contextlib.ExitStack() as exit_stack:
                exit_stack.push(cls._handle_exception)

                yield

        return context()
