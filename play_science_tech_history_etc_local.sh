#!/bin/bash

playlist_filename="temp_playlist.m3u"
#player_command="smplayer ${playlist_filename}"
#player_command="nvlc --loop --random --playlist-autostart ${playlist_filename}"
#player_command="vlc --loop --random --playlist-autostart ${playlist_filename}"
player_command="celluloid ${playlist_filename}"

rm ${playlist_filename}

for f in `cat science_tech_history_etc.m3u` ; do
#for f in `cat science_tech_history_etc.m3u | head -n 3` ; do
    echo ============= ${f} ================

    for url in `curl --silent ${f} | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*(mp3|mp4|m4a|ogg)" | uniq | head -n 2`; do
       echo ${url}
       #smplayer -add-to-playlist ${url} > /dev/null
       echo ${url} >> ${playlist_filename}
    done
#    sleep 5
done

${player_command} &
