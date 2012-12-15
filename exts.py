#!/usr/bin/env python
import sys
import os.path

if 2 == len(sys.argv) and sys.argv[1] in ('-h', '--help'):
	sys.stderr.write("exts gives you information about the extensions of the files in a directory, recursively.\n\nUsage: exts [directory]\n")
	sys.exit(0)

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
