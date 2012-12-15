#!/usr/bin/env python
import os
import sys
import threading

VOICE='Agnes'
TEXT='kaboom'

def usage():
    print >>sys.stderr, sys.argv[0], "<seconds> [<text-to-say>]\n\nSays the texts after the specified number of seconds. Default text is '%s'" % TEXT

def shell_escape(s):
    return "'"+s.replace("'", "\\'")+"'"

def timer(seconds, text):
    threading.Timer(seconds, lambda: os.system('say -v %s %s' % (VOICE, shell_escape(text)))).start()

if __name__ == '__main__':
    if (len(sys.argv) == 2):
        sys.argv.append(TEXT)
    if (len(sys.argv) != 3):
        usage()
        sys.exit(1)
    timer(int(sys.argv[1]), sys.argv[2])