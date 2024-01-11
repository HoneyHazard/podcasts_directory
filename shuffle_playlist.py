#!/bin/python

import random

def shuffle_m3u(input_file, output_file):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    header = lines.pop(0) if lines and lines[0].startswith('#EXTM3U') else ''
    entries = []

    i = 0
    while i < len(lines):
        if lines[i].startswith('#EXTINF:'):
            entry = lines[i]
            i += 1
            while i < len(lines) and not lines[i].startswith('#EXTINF:'):
                entry += lines[i]
                i += 1
            entries.append(entry)
        else:
            i += 1

    random.shuffle(entries)

    with open(output_file, 'w') as outfile:
        outfile.write(header)
        for entry in entries:
            outfile.write(entry)

if __name__ == "__main__":
    input_playlist = "temp_playlist.m3u"
    output_playlist = "shuffled_playlist.m3u"
    shuffle_m3u(input_playlist, output_playlist)

