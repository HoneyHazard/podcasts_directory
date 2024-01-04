#!/bin/python

import random
import sys

# Function to shuffle an M3U playlist while preserving comments and metadata
def shuffle_playlist(input_playlist='temp_playlist.m3u', output_playlist='temp_playlist.m3u'):
    with open(input_playlist, 'r') as file:
        lines = file.readlines()

    # Extracting entries from the playlist and preserving comments/metadata
    entries_with_metadata = []
    metadata = []
    for line in lines:
        line = line.strip()
        if line and not line.startswith('#'):
            entries_with_metadata.append(line)
        elif line.startswith('#'):
            metadata.append(line)

    # Shuffling the playlist entries
    random.shuffle(entries_with_metadata)

    # Writing shuffled entries along with comments/metadata to a new playlist file
    with open(output_playlist, 'w') as file:
        file.write('\n'.join(metadata) + '\n')  # Writing metadata/comments first
        for entry in entries_with_metadata:
            file.write(entry + '\n')  # Writing shuffled entries

    print(f"Playlist '{input_playlist}' shuffled while preserving comments/metadata and saved as '{output_playlist}'.")

if __name__ == "__main__":
    # Usage: python script_name.py input_playlist.m3u output_playlist.m3u
    input_file = 'temp_playlist.m3u' if len(sys.argv) < 2 else sys.argv[1]
    output_file = 'temp_playlist.m3u' if len(sys.argv) < 3 else sys.argv[2]
    
    shuffle_playlist(input_file, output_file)
#python


