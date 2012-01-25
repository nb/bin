#!/usr/bin/env python
import sys
import os.path

path = sys.argv[1] if len(sys.argv) > 1 else '.'

counts = {}
def recurse(arg, dirname, filenames):
	for name in filenames:
		extension = os.path.splitext(name)[1]
		counts[extension] = counts.get(extension, 0) + 1

os.path.walk(path, recurse, None)

for extension, count in sorted(counts.items(), key=lambda x: x[1]):
	if extension:
		print "%s: %s" % (extension, counts[extension])