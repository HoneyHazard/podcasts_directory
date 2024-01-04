#!/bin/python

import random
import sys

# Function to shuffle an M3U playlist while preserving comments and entry associations
def shuffle_playlist(input_playlist='temp_playlist.m3u', output_playlist='temp_playlist.m3u'):
    with open(input_playlist, 'r') as file:
        lines = file.readlines()

    # Extracting comments, entries, and their association
    entries_with_comments = []
    current_comment = ''
    for line in lines:
        line = line.strip()
        if line.startswith('#'):
            current_comment = line
        elif line:
            entries_with_comments.append((current_comment, line))
        else:
            entries_with_comments.append(('', ''))  # Handling entries without comments

    # Shuffling the playlist entries while maintaining comments association
    random.shuffle(entries_with_comments)

    # Writing shuffled entries along with comments to a new playlist file
    with open(output_playlist, 'w') as file:
        for comment, entry in entries_with_comments:
            if comment:
                file.write(comment + '\n')
            if entry:
                file.write(entry + '\n')

    print(f"Playlist '{input_playlist}' shuffled while preserving comments/entry associations and saved as '{output_playlist}'.")

if __name__ == "__main__":
    # Usage: python script_name.py input_playlist.m3u output_playlist.m3u
    input_file = 'temp_playlist.m3u' if len(sys.argv) < 2 else sys.argv[1]
    output_file = 'temp_playlist.m3u' if len(sys.argv) < 3 else sys.argv[2]
    
    shuffle_playlist(input_file, output_file)
