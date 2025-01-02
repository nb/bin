#!/bin/bash
EXTRA_ARGS=""
if [ -n "$1" ]; then
    EXTRA_ARGS="-and -iname '$1'"
fi
FIND_CMD="find . \( -iname '*.mov' -or -iname '*.wmv' -or -iname '*.avi' -or -iname '*.mp4' -or -iname '*.mpg' -or -iname '*.mkv' \) $EXTRA_ARGS"
eval "$FIND_CMD" |  perl -MList::Util -e 'print List::Util::shuffle <>' | tee >(wc -l >&2) | head -n 1 | echo-and-open
