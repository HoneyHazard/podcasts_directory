#!/bin/python3

import sys
import os

def parse_m3u_playlist(file_path):
    podcasts = []
    with open(file_path, 'r') as file:
        title = None
        for line in file:
            line = line.strip()
            if line.startswith('#'):
                # Extract title from comments
                title = line.lstrip('#').strip() if line.strip('#').strip() else None
            elif line:
                # Non-empty line containing URL
                podcasts.append((line, title))
                title = None
    return podcasts

def generate_opml(podcasts):
    opml = '<?xml version="1.0" encoding="UTF-8"?>\n<opml version="1.0">\n\t<head>\n\t\t<title>Podcasts</title>\n\t</head>\n\t<body>\n'
    for url, title in podcasts:
        if title:
            opml += f'\t\t<outline type="rss" text="{title}" xmlUrl="{url}" />\n'
        else:
            opml += f'\t\t<outline type="rss" xmlUrl="{url}" />\n'
    opml += '\t</body>\n</opml>'
    return opml

def convert_m3u_to_opml(input_file_path):
    file_name, file_extension = os.path.splitext(input_file_path)
    output_file_path = f'{file_name}.opml'

    podcasts = parse_m3u_playlist(input_file_path)
    opml_content = generate_opml(podcasts)
    with open(output_file_path, 'w') as opml_file:
        opml_file.write(opml_content)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script_name.py input.m3u")
    else:
        input_file = sys.argv[1]
        convert_m3u_to_opml(input_file)
