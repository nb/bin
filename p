#!/bin/sh
find . -iname '*.mov' -or -iname '*.wmv' -or -iname '*.avi' -or -iname '*.mp4' -or -iname '*.mpg' -or -iname '*.mkv'  | perl -MList::Util -e 'print List::Util::shuffle <>' | head -n 1 | echo-and-open
