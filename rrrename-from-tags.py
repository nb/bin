#!/usr/bin/env python
# coding: utf-8
import os
import sys
import os.path
import getopt
from mutagen.easyid3 import EasyID3
from mutagen.mp4 import MP4

def tag_values(tags, keys):
    def tag_value(key):
        value = tags.get(key)
        if not value or len(value) < 1:
            return None
        return tags[key][0]
    return map(tag_value, keys)
    
def warn(message):
    sys.stderr.write(message+"\n")

def fix_filename(f):
    return f.replace(u'/', u' - ')
    
if len(sys.argv) == 1:
    sys.stderr.write('''%(prog)s renames music files according to their ID3 tags.
    
Usage: %(prog)s [-a] FILE [FILE...]
    
The default format is:
<Artist> - <Track Name>.<Extension>

If the "-a" switch is given, the format is:
<Artist> - <Track Number> - <Track Name>.<Extension>

Files with mp3 and m4a extensions are supported.

This program requires the Mutagen python library: http://code.google.com/p/mutagen/''' % {'prog': os.path.basename(sys.argv[0])})
    sys.exit(1)

options, args = getopt.getopt(sys.argv[1:], '-a', ['album'])

album = any((opt[0] in ('-a', '--album') for opt in options))

for f in args:
    artist, track, number, extension = None, None, None, None
    if f.endswith('.mp3'):
        tags = EasyID3(f)
        artist, track, number = tag_values(tags, ['artist', 'title', 'tracknumber'])
        number = number.split('/')[0] if number else None
        extension = 'mp3'
    elif f.endswith('.m4a'):
        tags = MP4(f).tags
        artist = tags['\xa9ART'][0]
        track = tags['\xa9nam'][0]
        number = tags['trkn'][0][0]
        extension = 'm4a'
    if artist is None or track is None:
        warn('Skippping "%s". Missing artist or track.' % f)
        continue
    if album and number is None:
        warn('Skippping "%s". Missing track number in album mode.' % f)
        continue
    if album:
        new_name = fix_filename(u'%s - %02d - %s.%s' % (artist, int(number), track, extension))
    else:
        new_name = fix_filename(u'%s - %s.%s' % (artist, track, extension))
    os.rename(f, new_name)
    print u'%s → %s' % (unicode(f, 'UTF-8'), new_name)
        
